set_xmakever("3.0.7")
set_policy("check.auto_ignore_flags", false)
includes("options.lua")

add_imports("lib.detect.find_program")
add_moduledirs(os.projectdir() .. "/build-aux")
add_imports("miscs")
add_requires("lua")
add_rules("mode.debug", "mode.release")

local rel_type = 'a' -- or b(eta) or r(c) - empty for stable
version = os.date("%y%d%m") .. rel_type
set_version(version)
programs = { }
local install = false

for _, dir in ipairs(os.dirs("src/*")) do
	local name = path.filename(dir)
    local srcfile = "src/" .. name .. "/" .. name .. ".pp"

	if not os.isfile(srcfile) then
        goto continue
    end

    table.insert(programs, name)

    target(name)
        set_kind("binary")
        add_files(srcfile)
        add_packages("lua")

        add_pcflags(
            "@cc.cfg", -- config file for flags
            "-Fisrc/" .. name -- include dir
        )

        if is_mode("debug") then
            add_defines("DEBUG")
        end

        if has_config("output-prefix") then
            set_basename(get_config("output-prefix") .. name)
        end

        if not is_plat("windows") then
            add_defines("USE_LIBLUA")
        end

        on_config( function (target)
            -- xmake install checks for target:targetfile() (aka the target's executable)
            -- If it does not exist, xmake will tell the user to build it.
            -- This fools the build system to continue the installation. Will be removed
            -- later in before_build() below.
            os.mkdir(target:targetdir())
            os.touch(target:targetfile())

            -- Append @extra.cfg to compiler flags if extra.cfg exists
            target:add("pcflags", miscs.get_custom_fpc_conf())
        end)

        before_build( function (target)
            if os.getenv("CC_VERSION") == nil then
                os.setenv("CC_VERSION", import("core.project.project").version())
            end

            -- Where to search for compiled i18n - that %s is kept for FCL's gettext
            os.setenv('LOC_PATH',
                install and "/usr/share/locale/%s/LC_MESSAGES/" .. name .. ".mo"
                        or os.projectdir() .. "/src/" .. name .. "/i18n/%s/cc.mo")

            -- Remove the dummy file
            local targetfile = target:targetfile()
            if os.isfile(targetfile) then
                os.rm(targetfile)
            end
        end)

        after_build( function (target)
            -- PPUDump options (must be put before file names)
            --     -F<format>  Set output format to <format>: we only care about j(SON)
            --     -M Exit with ExitCode=2 if more information is available
            --     -S Skip PPU version check. May lead to reading errors
            --     -V<verbose>  Set verbosity to <verbose>
            --                    H - Show header info
            --                    I - Show interface
            --                    M - Show implementation
            --                    S - Show interface symbols
            --                    D - Show interface definitions
            --                    A - Show all
            local ppudump = find_program("ppudump", { check = "-h" })
            local out, err = os.iorunv(ppudump, table.join(
                { "-VI", "-Fj" },
                os.files(target:objectdir() .. "/*.ppu"))
            )
            if not miscs.is_string_empty(err) then
                print("error dumping infos from PPUs:")
                print(err)
                return
            end

            import("core.base.json")
            local depends = os.files("src/" .. name .. "/*", true)

            -- All programs use cc.getopts and have localizations
            table.insert(depends, "include/cc.getopts.inc")
            table.insert(depends, "include/i18n.inc")
            depends = table.join(depends, os.files("src/shared/argpas/*.pp"))

            -- Read the dumped PPU data. It is an array with the following keys
            -- Files: array of files that made the unit. Unused as there is no edge-cases
            -- Units: used units in both interface and implementation sections
            -- Ignore everything else. RTL, FCL etc units are not included in the depends table.
            for _, obj in ipairs(json.decode(out)) do
                for __, unit in ipairs(obj["Units"]) do
                    if unit:startswith("cc.") or unit:startswith("lua") or
                       unit == "lauxlib" then
                        table.insert(depends, "include/" .. unit .. ".inc")
                        table.insert(depends, "src/shared/" .. unit .. ".pp")
                    elseif unit == "i18n" then
                        table.insert(depends, "src/" .. name .. "/i18n.inc")
                    end
                end
            end

            -- target:dependfile() contains serialized Lua table (lol)
            local depf = io.load(target:dependfile())
            depf["files"] = table.unique(table.join(depends, depf["files"]))
            io.writefile(target:dependfile(), string.serialize(depf))
        end)

        before_install( function (target)
            import("core.base.task")
            install = true
            task.run("build", { target = name, no_rebuild = true })
            task.run("i18n", { task = "all", what = name })
            task.run("docs", { task = "build", what = name })
            for __, fullpath in ipairs(os.dirs("src/" .. name .. "/i18n/*")) do
                target:add("installfiles", fullpath .. "/cc.mo", {
                    prefixdir = "share/locale/" .. path.filename(fullpath) .. "/LC_MESSAGES/",
                    filename = name .. ".mo"
                })
            end
        end)

        add_installfiles("docs/1/cc-" .. name .. ".1", { prefixdir = "share/man/man1" })

    ::continue::
end

target("API")
    set_kind("phony")
    set_default(false)

    on_install( function (_)
        raise(
            "error: Installation for this target is NOT supported!\n" ..
            "What to install are src/shared/cc.*.{o,ppu}. Install to a " ..
            "supported directory in your fpc.cfg."
        )
    end)

    on_build( function (_)
        local args = { "@cc.cfg", miscs.get_custom_fpc_conf() }
        if is_mode("debug") then
            table.insert(args, "-dDEBUG")
        end

        for __, fullpath in ipairs(os.files("src/shared/cc.*.pp")) do
            import("core.project.config")

            local firstln = table.to_array(io.lines(fullpath))[1]:split(' ')
            if firstln[2] == "SKIP" then -- Platform-specific unit
                if table.contains(firstln, config.plat()) then
                    cprint("${yellow}skipping " .. fullpath ..
                           " for not supporting " .. config.plat() .. "${clear}")
                    goto continue
                end
            end

            print("compiling " .. fullpath .. " ...")
            local compiler = config.get("pc")
            -- tested: errors will still be printed to XMake
            -- however warnings, infos and such will not be shown
            os.runv(miscs.is_string_empty(compiler) and "fpc" or compiler,
                    table.join(args, fullpath))

            ::continue::
        end
    end)

    on_clean( function (_)
        os.rm("i18n/*/cc.mo")
        os.rm("src/shared/*.o")
        os.rm("src/shared/*.ppu")
        os.rm("src/shared/*.rsj")
    end)

target("programs")
	set_kind("phony")
	set_default(true)
    add_deps(programs)

includes("i18n/xmake.lua", "docs/xmake.lua")

target('test')
    add_files('test.c')

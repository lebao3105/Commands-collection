add_imports("lib.detect.find_program")
set_policy("check.auto_ignore_flags", false)

add_moduledirs(os.projectdir() .. "/build-aux")
add_imports("miscs")

add_rules("mode.debug", "mode.release")

local rel_type = 'a' -- or b(eta) or r(c) - empty for stable
version = os.date("%y%d%m") .. rel_type
set_version(version)
programs = { }
local install = false

includes("options.lua")

for i, dir in ipairs(os.dirs("src/*")) do
	local name = path.filename(dir)
    local srcfile = "src/" .. name .. "/" .. name .. ".pp"

	if not os.isfile(srcfile) then
        goto continue
    end

    table.insert(programs, name)

    target(name)
        set_kind("binary")
        add_files(srcfile)
        add_links("c")

        add_pcflags(
            "@cc.cfg", -- config file for flags
            "-Fisrc/" .. name -- include dir
        )

        if is_mode("debug") then
            add_pcflags("-dDEBUG")
        end

        if has_config("output-prefix") then
            set_basename(get_config("output-prefix") .. name)
        end

        on_config( function (target)
            -- xmake install checks for target:targetfile() (aka the target's executable)
            -- If it does not exist, xmake will tell the user to build it.
            -- This fools the build system to continue the installation. Will be removed
            -- later in before_build() below.
            os.touch(target:targetfile())
            target:add("pcflags", miscs.get_custom_fpc_conf())
        end)

        before_build( function (target)
            -- version variable is nil
            target:add("pcflags", "-dCC_VERSION:=" .. miscs.single_string_quote(
                import("core.project.project").version()
            ))
            os.setenv('LOC_PATH',
                install and "/usr/share/locale/%s/LC_MESSAGES/" .. name .. ".mo"
                        or os.projectdir() .. "/src/" .. name .. "/i18n/%s/cc.mo")

            if os.exists(target:targetfile()) then
                os.rm(target:targetfile())
            end
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
            print("compiling " .. fullpath .. " ...")
            import("core.project.config")
            local compiler = config.get("pc")
            -- tested: errors will still be printed to XMake
            -- however warnings, infos and such will not be shown
            os.runv(miscs.is_string_empty(compiler) and os.which("fpc") or compiler,
                    table.join(args, fullpath))
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

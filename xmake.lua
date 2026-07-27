set_xmakever("3.0.7")
set_policy("check.auto_ignore_flags", false)
includes("options.lua")

add_imports("lib.detect.find_program")
add_moduledirs(os.projectdir() .. "/build-aux")
add_imports("miscs")
add_requires("lua 5.5.0", { configs = { shared = true } })
-- add_requires("gettext", { system = false, optional = true })
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
        -- add_links(is_plat("windows") and 'msvcrt' or 'c')

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
            add_defines("USE_VT_SEQ")
        else
            add_pcflags("-WC") -- Same as {$apptype console}?
            if not get_config("use-win-console") then
                add_defines("USE_VT_SEQ")
            end
        end

        on_config( function (target)
            -- xmake install checks for target:targetfile() (aka the target's executable)
            -- If it does not exist, xmake will tell the user to build it.
            -- This fools the build system to continue the installation. Will be removed
            -- later in before_build() below.
            os.mkdir(target:targetdir())
            os.touch(target:targetfile())

            os.mkdir(target:objectdir())

            -- Append @extra.cfg to compiler flags if extra.cfg exists
            target:add("pcflags", miscs.get_custom_fpc_conf())
        end)

        before_build( function (target)
            if os.getenv("VERSION") == nil then
                os.setenv("VERSION", import("core.project.project").version())
            end

            -- Where to search for compiled i18n - that %s is kept for FCL's gettext
            os.setenv('LOC_PATH',
                install and "/usr/share/locale/%s/LC_MESSAGES/" .. name .. ".mo"
                        or os.projectdir() .. "/i18n/%s/" .. name .. ".mo")

            -- Remove the dummy file
            local targetfile = target:targetfile()
            if os.isfile(targetfile) then
                os.rm(targetfile)
            end
        end)

        before_install( function (target)
            import("core.base.task")
            install = true
            task.run("build", { target = name })
            task.run("i18n", { task = "all", what = name, no_rebuild = true })
            task.run("docs", { task = "build", what = name })
            for __, fullpath in ipairs(os.dirs("i18n/*")) do
                target:add("installfiles", fullpath .. "/" .. name .. ".mo", {
                    prefixdir = "share/locale/" .. path.filename(fullpath) .. "/LC_MESSAGES/",
                    filename = name .. ".mo"
                })
            end
        end)

        add_installfiles("docs/1/cc-" .. name .. ".1", { prefixdir = "share/man/man1" })

    ::continue::
end

includes("i18n/xmake.lua", "docs/xmake.lua")

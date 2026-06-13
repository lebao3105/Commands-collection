add_imports("lib.detect.find_program", "lib.detect.find_file")
set_policy("build.progress_style", "multirow")
set_policy("check.auto_ignore_flags", false)

add_moduledirs(os.projectdir() .. "/build-aux")
add_imports("miscs")

add_rules("mode.debug", "mode.release")

local rel_type = 'a'
version = os.date("%y%d%m") .. rel_type
set_version(version)
programs = { }

includes("options.lua", "@builtin/xpack")

for i, dir in ipairs(os.dirs("src/*")) do
	local name = path.filename(dir)
    local srcfile = "src/" .. name .. "/" .. name .. ".pp"

	if not os.isfile(srcfile) then
        goto continue
    end

    programs[i] = name

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

        before_build( function (target)
            target:add("pcflags", miscs.get_custom_fpc_conf())
            os.setenv('CC_VERSION', version)

            local locpath = xpack and
                "/usr/share/locale/%s/LC_MESSAGES/" .. name .. ".mo" or
                os.projectdir() .. "/src/" .. name .. "/i18n/%s/cc.mo"
            os.setenv('LOC_PATH', locpath)

            os.mkdir(target:objectdir())
        end)

    ::continue::
end

target("API")
    set_kind("phony")
    on_build( function (_)
        local args = { "-dNO_PROG", "@cc.cfg", miscs.get_custom_fpc_conf() }

        for __, fullpath in ipairs(os.files("src/shared/cc.*.pp")) do
            os.execv(miscs.get_fpc_path(), table.join(args, fullpath))
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

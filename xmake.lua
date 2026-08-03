set_xmakever("3.0.7")
if is_plat("wasm") then
    raise("this project does not support WASM!")
end

local buildaux = os.projectdir() .. "/build-aux/"
add_moduledirs(buildaux .. "utils")
add_repositories("3rd " .. buildaux .. "3rdparty")
add_imports("miscs", "targets")
includes(buildaux .. "options.lua")

option("output-prefix")
    set_showmenu(true)
    set_description("Prefix for built binaries - useful for co-use with ones like GNU Coreutils")
    set_default("cc-")
option_end()

add_requires("lua 5.5.0", { configs = { shared = true } })
add_requires("gettext", { optional = true })
add_requires("scdoc", { optional = true })
add_rules("mode.debug", "mode.release")
set_policy("check.auto_ignore_flags", false)

for _, dir in ipairs(os.dirs("src/*")) do
	local name = path.filename(dir)
    local srcfile = "src/" .. name .. "/" .. name .. ".pp"

	if not os.isfile(srcfile) then
        goto continue
    end

    target(name)
        set_kind("binary")
        set_toolchains("fpc")
        add_files(srcfile)

        if name == "dir" then
            add_packages("lua")
        end

        on_config(function (target)
            targets.on_target_config(target)
            target:add("pcflags", "@cc.cfg")
            target:add("pcflags", "-Fisrc/" .. name)
            if has_config("output-prefix") then
                target:set("basename", get_config("output-prefix") .. name)
            end
        end)

        before_build(function (target)
            targets.before_target_build(target, os.projectdir() .. "/i18n/%s/", name .. ".mo")
        end)

        before_install(function (target)
            targets.before_target_install(target)
            local pref = "cc-"
            if has_config("output-prefix") then
                pref = get_config("output-prefix")
            end
            target:add("installfiles", "docs/cc-" .. name .. ".1", {
                prefixdir = "share/man/man1", name = pref ..  name .. ".1" })
        end)


    ::continue::
end

includes(buildaux .. "tasks/docs.lua", buildaux .. "tasks/i18n.lua")

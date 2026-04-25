add_imports("lib.detect.find_program", "lib.detect.find_file")

add_moduledirs(os.projectdir() .. "/build-aux")
add_imports("i18n", "miscs", {inherit = true})

add_rules("mode.debug", "mode.release", "mode.releasedbg")
set_policy("check.auto_ignore_flags", false)

includes("@builtin/xpack")

version = "1.1.0alpha"
set_version(version)
programs = {}

option("output-prefix")
    set_showmenu(true)
    set_description("Prefix for built binaries - useful for co-use with ones like GNU Coreutils")
    if xpack then
        set_default("cc-")
    else
        set_default("")
    end

option("fpc-conf")
	set_showmenu(true)
	set_description("Path to fpc.cfg file - optional")
	set_default("")

option("use-unicode-rtl")
	set_showmenu(true)
	set_description("Use Unicode RTL and packages")
	set_default(false)

includes("i18n/xmake.lua")

for i, dir in ipairs(os.dirs("src/*", { async = true })) do
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
            "-Fisrc/" .. name, -- include dir
            "-dCC_VERSION:=\'" .. version .. "\'" -- version of CC
        )

        if has_config("output-prefix") then
            set_basename(get_config("output-prefix") .. name)
        end

        if get_config("use-unicode-rtl") then
            add_pcflags("-Municodestrings")
        end

        before_build(function (target)
            target:add("pcflags", miscs.get_custom_fpc_conf())

            local locpath = "-dLOC_PATH:="
            if xpack then
                locpath = locpath .. miscs.single_string_quote(
                    "/usr/share/locale/%s/LC_MESSAGES/" .. name .. ".mo"
                )
            else
                locpath = locpath .. miscs.single_string_quote(
                    os.projectdir() .. "/src/" .. name .. "/i18n/%s/cc.mo"
                )
            end
            target:add("pcflags", locpath)

            os.mkdir(target:objectdir())
        end)

    target(name .. "-docs")
        set_kind("phony")

        local groff_path = os.projectdir() .. "/docs/1/cc-" .. name .. ".1"

        on_build(function (_)
            miscs.scdoc_to_groff("docs/1/" .. name .. ".scd", groff_path)
        end)

        add_installfiles(groff_path, { prefixdir = "share/man/man1" })

    target(name .. "-i18n")
        add_deps(name)
        set_kind("phony")

        local i18n_dir = "src/" .. name .. "/i18n/"

        on_build(function (_)
            local potloc = i18n_dir .. "cc.pot"

            -- Generate a template
            local rsjpath = vformat(
                "$(builddir)/.objs/" .. name .. "/$(os)/$(arch)/$(mode)",
                xmake
            )
            i18n.generate_pot(rsjpath, potloc, true)

            for __, fullpath in ipairs(os.dirs(i18n_dir .. "*")) do
                local language = path.filename(fullpath)
                local ccpath = "i18n/" .. language
                local outpath = fullpath .. "/cc.po"

                -- Merge application's template to
                -- language-specific translation
                i18n.merge_po_files(potloc, outpath)

                -- Compile .po to .mo
                i18n.compile_po_files({outpath, ccpath .. "/cc.po"}, fullpath .. "/cc.mo")
            end
        end)

        for __, fullpath in ipairs(os.dirs(i18n_dir .. "*")) do
            add_installfiles(fullpath .. "/cc.mo", {
                prefixdir = "share/locale/" .. path.filename(fullpath) .. "/LC_MESSAGES/",
                filename = name .. ".mo"
            })
        end

    ::continue::
end

target("programs")
	set_kind("phony")
    add_deps(programs)

target("programs-i18n")
	set_kind("phony")
	for _, program in ipairs(programs) do
		add_deps(program .. "-i18n")
	end

target("programs-docs")
	set_kind("phony")
	for _, program in ipairs(programs) do
		add_deps(program .. "-docs")
	end

includes("docs/xmake.lua")
includes("build-aux/pack.lua")

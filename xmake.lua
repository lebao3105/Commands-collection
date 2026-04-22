add_imports("lib.detect.find_program", "lib.detect.find_file")

add_moduledirs(os.projectdir() .. "/build-aux")
add_imports("i18n", "miscs", {inherit = true})

add_rules("mode.debug", "mode.release", "mode.releasedbg")
set_policy("check.auto_ignore_flags", false)

local version = "1.1.0alpha"
set_version(version)
programs = {}

option("output-prefix")
    set_showmenu(true)
    set_description("Prefix for built binaries - useful for co-use with ones like GNU Coreutils")
    set_default("")

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

        local fpc_conf = get_config("fpc-conf")
        if fpc_conf ~= nil and fpc_conf:trim():len() > 0 then
            add_pcflags("@" .. get_config("fpc-conf"))
        end

        before_build(function (target)
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
        for __, fullpath in ipairs(os.dirs(i18n_dir .. "*")) do
            add_installfiles(fullpath .. "/cc.mo", {
                prefixdir = "share/locale/" .. path.filename(fullpath),
                filename = name .. ".mo"
            })
        end

        on_build(function (_)
            local potloc = i18n_dir .. "cc.pot"

            -- Generate a template
            local rsjpath = vformat(
                "$(builddir)/.objs/" .. name .. "/$(os)/$(arch)/$(mode)",
                xmake
            )
            i18n.generate_pot(rsjpath, potloc)

            -- Merge existing translations from CC
            for __, fullpath in ipairs(os.dirs(i18n_dir .. "*")) do
                local language = path.filename(fullpath)
                local ccpath = "i18n/" .. language
                local outpath = fullpath .. "/cc.po"

                i18n.merge_po_files(potloc, outpath)

                if os.isdir(ccpath) then
                    i18n.merge_po_files(ccpath .. "/cc.po", outpath)
                end

                -- Compile .po to .mo
                i18n.compile_po_file(outpath, fullpath .. "/cc.mo")
            end
        end)

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

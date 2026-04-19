add_imports("lib.detect.find_program", "lib.detect.find_file")

add_moduledirs(os.projectdir() .. "/build-aux")
add_imports("i18n", {inherit = true})

add_rules("mode.debug", "mode.release", "mode.releasedbg")
set_policy("check.auto_ignore_flags", false)

local version = "1.1.0alpha"
local programs = {}

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

rule("unit_pas")
	on_config(function (target)
		-- Where to get needed flags
		target:add("pcflags", "@cc.cfg")

		-- Define CC_VERSION (this project version)
		target:add("pcflags", "-dCC_VERSION:=\'" .. version .. "\'")

		if get_config("use-unicode-rtl") then
			target:add("pcflags", "-Municodestrings")
		end

		if get_config("fpc-conf") ~= "" then
			target:add("pcflags", "@" .. get_config("fpc-conf"))
		end

		os.mkdir(target:objectdir())
	end)

rule("program_pas")
	add_deps("unit_pas")
	on_config(function (target)
		local name = target:name()

		-- Source files
		target:add("files", "src/" .. name .. "/" .. name .. ".pp")

		-- Add include dirs
		target:add("pcflags", "-Fisrc/" .. name)

		-- Where to put binaries:
		-- $(builddir)/<os>/<arch>/<kind>/<output-prefix>name
		target:set("basename", get_config("output-prefix") .. name)
	end)

includes("i18n/xmake.lua")

for i, dir in ipairs(os.dirs("src/*", { async = true })) do
	local name = path.filename(dir)

	if os.isfile("src/" .. name .. "/" .. name .. ".pp") then
		target(name)
			set_kind("binary")
			add_rules("program_pas")

		target(name .. "-docs")
			on_build(function (_)
				local scdoc = find_program("scdoc", {
                    paths = { "$(env PATH)", "/usr/bin", "/usr/local/bin" },
                    check = "-h"
                })
				local inp = "docs/1/" .. name .. ".scd"
				local out = "docs/1/cc-" .. name .. ".man"

                if (scdoc == nil) then
                    print("scdoc not found, cannot generate man pages!")
				elseif os.isfile(inp) then
					os.execv(scdoc, {}, { stdin = inp, stdout = out })
				end
			end)

		target(name .. "-i18n")
			add_deps(name)

			on_build(function (_)
				local i18n_dir = "src/" .. name .. "/i18n/"
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

		programs[i] = name
	end
end

target("programs")
	set_kind("phony")
	for _, program in ipairs(programs) do
		add_deps(program)
	end

target("programs-i18n")
	set_kind("phony")
	for _, program in ipairs(programs) do
		add_deps(program .. "-i18n")
	end

includes("docs/xmake.lua")
includes("@builtin/xpack")

xpack("commands-collection")
	set_formats("zip", "nsis", "targz", "rpm", "deb", "dmg")
	set_title("Commands collection")
	set_author("lebao3105")
	set_description(
		"A pack of command-line utilities, found in daily usages." ..
		"While this does not conflict with GNU Coreutils and such, " ..
		"it is not very nice to add a cc- prefix to programs that this " ..
		"project provides. Use at your own risk!"
	)
	set_homepage("https://gitlab.com/lebao3105/commands-collection")
	set_licensefile("LICENSE")

	for _, program in ipairs(programs) do
		add_targets(program)
		add_targets(program .. "-i18n")
	end
	add_targets("API-docs", "API-i18n")

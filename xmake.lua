add_imports("lib.detect.find_program", "lib.detect.find_file")
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

rule("unit_pas")
	on_config(function (target)
		local objdir = "$(builddir)/.objs/" .. target:name()
		os.mkdir(objdir)

		-- Where to put build outputs
		target:add("pcflags", "-FU" .. objdir)

		-- Where to get needed flags
		target:add("pcflags", "@cc.cfg")

		-- Define CC_VERSION (this project version)
		target:add("pcflags", "-dCC_VERSION:=\'" .. version .. "\'")

		if get_config("fpc-conf") ~= "" then
			target:add("pcflags", "@" .. get_config("fpc-conf"))
		end
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
				local scdoc = find_program("scdoc")
				local inp = "docs/1/" .. name .. ".scd"
				local out = "docs/1/cc-" .. name .. ".man"

				if os.isfile(inp) and (not scdoc == nil) then
					os.execv(scdoc, {}, { stdin = inp, stdout = out })
				end
			end)
		
		target(name .. "-i18n")
			add_deps(name)

			on_build(function (_)
				local i18n_dir = "src/" .. name .. "/i18n/"
				local potloc = i18n_dir .. "cc.pot"

				-- Generate a template
				generate_pot("$(builddir)/.objs/" .. name, potloc)

				-- Merge existing translations from CC
				for __, fullpath in ipairs(os.dirs(i18n_dir .. "*")) do
					local language = path.filename(fullpath)
					local ccpath = "i18n/" .. language
					local outpath = fullpath .. "/cc.po"
					
					merge_po_files(potloc, outpath)
					
					if os.isdir(ccpath) then
						merge_po_files(ccpath .. "/cc.po", outpath)
					end

					-- Compile .po to .mo
					compile_po_file(outpath, fullpath .. "/cc.mo")
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
	set_description("A pack of command-line utilities.")
	set_homepage("https://gitlab.com/lebao3105/commands-collection")
	set_licensefile("LICENSE")

	for _, program in ipairs(programs) do
		add_targets(program)
		-- add_targets(program .. "-i18n")
	end
	-- add_targets("API-docs", "API-i18n")

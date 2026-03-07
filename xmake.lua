add_imports("lib.detect.find_program", "lib.detect.find_file")

add_rules("mode.debug", "mode.release", "mode.releasedbg")
-- add_rules("plugin.compile_commands.autoupdate")
set_policy("check.auto_ignore_flags", false)

local version = "1.1.0alpha"
local programs = {}

option("fpc-conf")
	set_showmenu(true)
	set_description("Path of FPC's generated fpc.cfg")
	set_default("/etc/fpc.cfg")

option("output-prefix")
    set_showmenu(true)
    set_description("Prefix for built binaries - useful for co-use with ones like GNU Coreutils")
    set_default("")

rule("program_pas")
	on_config(function (target)
		local name = target:name()
		local objdir = "$(buildir)/.objs/" .. name

		-- Source files
		target:add("files", "src/" .. name .. "/" .. name .. ".pp")

		-- Where to get needed flags
		target:add("pcflags", "@$(fpc-conf)", "@fpc.cfg")

		-- Define CC_VERSION (this project version)
		target:add("pcflags", "-dCC_VERSION:=\'" .. version .. "\'")

		-- Add include dirs
		target:add("pcflags", "-Fisrc/" .. name)

		-- Set the output directory for .o and .ppu files
		target:add("pcflags", "-FU" .. objdir)

		-- Where to put binaries:
		-- $(builddir)/<os>/<arch>/<kind>/name/name
		target:set("basename", name .. "/" .. name)

		-- Create needed directories
		os.mkdir(objdir)
	end)


rule("API_docs")
	set_extensions(".inc", ".pp")
	on_build_file(function (_, sourcefile, __)
		import("core.project.depend")
		local defines = {}
		local i = 0

		if not os.isdir("docs/api/") then
			os.mkdir("docs/api/")
		end

		for line in io.lines("fpc.cfg") do
			if line:startswith("-d") then
				defines[i] = '--define ' .. line:split("-d")[1]
				i = i + 1
			end
		end

		depend.on_changed(
			function ()
				os.execv("pasdoc", table.join(defines, {"@pasdoc.cfg", "include/*"}))
			end,
			{
				files = {
					sourcefile
				}
			}
		)
	end)

for i, dir in ipairs(os.dirs("src/*", { async = true })) do
	local name = path.filename(dir)

	if os.isfile("src/" .. name .. "/" .. name .. ".pp") then
		target(name)
			-- add_rules("program_pas", "program_docs")
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

		programs[i] = name
	end
end

target("API-docs")
	add_rules("API_docs") -- TODO: Rename
	add_files("include/*.inc")

target("update-locals")
	add_deps(programs)

	on_build(function (_)
		local xgettext = find_program("xgettext")
		local msgmerge = find_program("msgmerge")
		local potloc = "i18n/cc.pot"

		if xgettext == nil then
			error("Failed to find xgettext!")
			return
		end

		if msgmerge == nil then
			error("Failed to find msgmerge!")
			return
		end
		
		-- Start freshly
		if os.isfile(potloc) then
			os.rm(potloc)
		end
		os.touch(potloc)

		-- Generate a template
		for __, fullpath in ipairs(os.files("$(buildir)/**/*.rsj", { async = true }))
		do
			print("Found a .rsj file for localization: " .. fullpath)
			os.execv(xgettext, {"-o", potloc, "-E", "-i",
								"--add-comments=TRANSLATORS",
								"-j", fullpath })
		end

		-- Merge existing translations
		for __, fullpath in ipairs(os.dirs("i18n/*")) do
			local outpath = fullpath .. "/cc.po"
			if os.exists(outpath) then
				os.execv(msgmerge, { "-U", "-i", outpath, potloc })
			else
				os.cp(potloc, outpath)
			end
		end

	end)

target("compile-locals")
	on_build(function (_)
		local msgfmt = find_program("msgfmt")

		if msgfmt == nil then
			error("Failed to find msgfmt!")
			return
		end

		for __, fullpath in ipairs(os.dirs("i18n/*")) do
			os.execv(msgfmt, { fullpath .. "/cc.po", "-o", fullpath .. "/cc.mo" })
		end
	end)

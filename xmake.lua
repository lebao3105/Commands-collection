add_imports("lib.detect.find_program", "lib.detect.find_file")
add_rules("mode.debug", "mode.release", "mode.releasedbg")
set_policy("check.auto_ignore_flags", false)

local version = "1.1.0alpha"
local programs = {}

option("output_prefix")
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

for i, dir in ipairs(os.dirs("src/*", { async = true })) do
	local name = path.filename(dir)

	if os.isfile("src/" .. name .. "/" .. name .. ".pp") then
		target(name)
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

includes("i18n/xmake.lua")
includes("docs/xmake.lua")

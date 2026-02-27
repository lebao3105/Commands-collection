add_rules("mode.debug", "mode.release", "mode.releasedbg")
add_rules("plugin.compile_commands.autoupdate")

option("fpc_conf")
	set_showmenu(true)
	set_description("Path of FPC's generated fpc.cfg")
	set_default("/etc/fpc.cfg")

option("output_prefix")
    set_showmenu(true)
    set_description("Prefix for built binaries - useful for co-use with ones like GNU Coreutils")
    set_default("")

rule("program_pas")
	on_config(function (target)
		local name = target:name()
		target:add("files", "src/" .. name .. "/" .. name .. ".pp")
		target:add("pcflags", "@$(fpc_conf)", "@fpc.cfg", { force=true })
		target:add("includedirs", "include", "src/" .. name)
		target:set("objectdir", "$(builddir)/.objs/" .. name)
		target:set("basename", name .. "/" .. name)
		-- For older XMakes
		target:add("pcflags", "-Fisrc/" .. name, { force=true })
	end)

for _, dir in ipairs(os.dirs("src/*")) do
	local name = path.filename(dir)
	if os.isfile("src/" .. name .. "/" .. name .. ".pp") then
		target(name)
			add_rules("program_pas")
	end
end

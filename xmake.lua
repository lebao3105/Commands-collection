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

target("bridge")
    set_kind("shared")
    add_files("src/cc.bridge.pp")
    add_pcflags("@$(fpc_conf)", "@fpc.cfg", {force=true})
    add_includedirs("include")

target("custcustc")
	set_kind("static")
	set_prefixname("$(target_program)/lib")
	add_files("src/*.c")
    add_deps("bridge")
	add_defines("PROG_CONFIG_PATH=\"../src/$(target_program)/config.h\"")

target("selected")
	set_kind("binary")
	set_basename("$(target_program)/$(output_prefix)$(target_program)")
	set_objectdir("$(builddir)/.objs")

	add_deps("custcustc", "bridge")
	add_files("src/$(target_program)/$(target_program).pp")
	add_pcflags("@$(fpc_conf)", "@fpc.cfg", {force=true})
	add_includedirs("include")
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

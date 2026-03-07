add_rules("mode.debug", "mode.release", "mode.releasedbg")
add_rules("plugin.compile_commands.autoupdate")

option("target_program")
	set_showmenu(true)
	set_description("The program to be built")

option("output_prefix")
    set_showmenu(true)
    set_description("Prefix for built binaries - useful for co-use with ones like GNU Coreutils")
    set_default("")

target("bridge")
    set_kind("shared")
    add_files("src/cc.bridge.pp")
    add_pcflags("@cc.cfg", {force=true})
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
	add_pcflags("@cc.cfg", {force=true})
	add_includedirs("include")

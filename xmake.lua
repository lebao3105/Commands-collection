add_rules("mode.debug", "mode.release", "mode.releasedbg")
add_rules("plugin.compile_commands.autoupdate")

option("target_program")
	set_showmenu(true)
	set_description("The program to be built")

option("fpc_conf")
	set_showmenu(true)
	set_description("Path of FPC's generated fpc.cfg")
	set_default("/etc/fpc.cfg")

target("custcustc")
	set_kind("static")
	set_prefixname("$(target_program)/lib")
	add_files("src/logging.c", "src/termcolor.c")
	add_defines("PROG_CONFIG_PATH=\"../src/$(target_program)/config.h\"")

target("selected")
	set_kind("binary")
	set_basename("$(target_program)/$(target_program)")
	set_objectdir("$(builddir)/.objs")

	add_deps("custcustc")
	add_files("src/$(target_program)/$(target_program).pp")
	add_pcflags("@$(fpc_conf)", "@fpc.cfg", { force=true })
	add_includedirs("include", "src/$(target_program)")

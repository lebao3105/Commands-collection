add_rules("mode.debug", "mode.release", "mode.releasedbg")
add_rules("plugin.compile_commands.autoupdate")

option("target_program")
	set_showmenu(true)
	set_description("The program to be built")

target("custcustc")
	set_kind("static")
	set_prefixname("$(target_program)/lib") -- Dirty trick, I know
	add_files("src/*.c")
	add_defines("PROG_CONFIG_PATH=\"../src/$(target_program)/config.h\"")

target("selected")
	set_kind("binary")
	set_basename("$(target_program)/$(target_program)")
	set_exceptions("fpc")
	set_objectdir("$(builddir)/.objs")

	add_deps("custcustc")
	add_files("src/$(target_program)/$(target_program).pp")
	add_pcflags(
	    "-Sa", "-Si", "-Sm", "-Sc", "-Sh", "-Co", "-CO", "-gl", "-Fusrc")
	add_defines(
		"bg:=begin", "ed:=end", "retn:=procedure",
		"fn:=function", "long:=longint", "ulong:=longword",
	    "int:=integer", "bool:=boolean", "return:=exit",
        "CUSTCUSTC_EXTERN:=external 'custcustc' name"
	)
	add_includedirs("include")

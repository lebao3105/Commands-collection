option("fpc-conf")
	set_showmenu(true)
	set_description("Path to a compiler configuration file - optional")
	set_default("")

option("use-valgrind")
    set_showmenu(true)
    set_description("Generate debug symbols for Valgrind instead of DWARF")
    set_default(true)
    add_pcflags("-gv")

option("output-prefix")
    set_showmenu(true)
    set_description("Prefix for built binaries - useful for co-use with ones like GNU Coreutils")
    set_default("cc-")

function getOutputPrefix()
    return get_config("output-prefix")
end

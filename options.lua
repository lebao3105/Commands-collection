-- Available platforms can be seen at XMake dir/platforms
-- Each folder is a platform (except `cross`)
if is_plat("iphoneos", "watchos") then
    cprint("${blue}note: you'll have to have something like " ..
           "jailbroken iOS to use this product.${clear}")
elseif is_plat("android") then
    cprint("${blue}note: Use something like Termux (proot and such " ..
           "doesn't count as compiling for Android). Also FPC for Android " ..
           "is known to be broken, consider using a cross-compiler.${clear}")
elseif is_plat("haiku", "bsd", "harmony") then
    cprint("${color.warning}there is very limited support for the current " ..
           "build platform due to different API set and/or lack of testers.")
elseif is_plat("wasm") then
    raise("this project does not support WASM!")
end

option("use-valgrind")
    set_showmenu(true)
    set_description("Generate debug symbols for Valgrind instead of DWARF")
    set_default(true)
    add_pcflags("-gv")

option("output-prefix")
    set_showmenu(true)
    set_description("Prefix for built binaries - useful for co-use with ones like GNU Coreutils")
    set_default("cc-")

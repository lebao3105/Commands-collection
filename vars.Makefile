# Output options
# https://forum.lazarus.freepascal.org/index.php?topic=34898.0
build_obj := build/obj_out
build_progs := build/progs
OPTIONS=-FE../$(build_progs) -FU../$(build_obj) -Fu../include/ -vh -vw -Si -g -Sh
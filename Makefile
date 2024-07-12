# Output options
# https://forum.lazarus.freepascal.org/index.php?topic=34898.0
build_obj := build/obj_out
build_progs := build/progs
options := -FE$(build_progs) -FU$(build_obj) -Fuinclude/

# Targets

# Build everything
all: init cat check_file_type calltime dir getvar mkdir presskey printf rename rm

cat: init_ cat/cat.pas
	fpc cat/cat.pas $(options) -Fuinclude/

check_file_type: init_ check_file_type/chk_type.pas
	fpc check_file_type/chk_type.pas $(options) -Fuinclude/

calltime: init_ calltime/calltime.pas
	fpc calltime/calltime.pas $(options)

dir: init_ dir/dir.pas
	fpc dir/dir.pas -Fuinclude/ $(options)

getvar: init_ getvar/getvar.pas
	fpc getvar/getvar.pas $(options) -Fuinclude/

includes: init_ $(wildcard include/*.pas)
	fpc include/include.pas $(options)

mkdir: init_ mkdir/mkdir.pas
	fpc mkdir/mkdir.pas $(options) -Fuinclude/

presskey: init_ presskey/presskey.pas
	fpc presskey/presskey.pas $(options) -Fuinclude/

printf: init_ printf/printf.pas
	fpc printf/printf.pas $(options) -Fuinclude/

rename: init_ rename/rename.pas
	fpc rename/rename.pas $(options) -Fuinclude/

rm: init_ rm/rm.pas
	fpc rm/rm.pas $(options) -Fuinclude/

touch: init_ touch/touch.pas
	fpc touch/touch.pas $(options) -Fuinclude/

init_:
ifeq ($(DO_CLEAN), 1)
	$(MAKE) clean
endif

# Pack

# Clean
clean:
	$(RM) -rf $(wildcard $(build_obj)/*) $(wildcard $(build_progs)/*)

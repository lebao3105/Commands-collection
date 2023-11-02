# Included units
include_path := include/

# Output options
# https://forum.lazarus.freepascal.org/index.php?topic=34898.0
build_obj := build/obj_out
build_progs := build/progs
options := -FE$(build_progs) -FU$(build_obj)

# Targets
cat: init_ cat/cat.pas
	fpc cat/cat.pas $(options) -Fu$(include_path)

check_file_type: init_ check_file_type/chk_type.pas
	fpc check_file_type/chk_type.pas $(options) -Fu$(include_path)

calltime: init_ calltime/calltime.pas
	fpc calltime/calltime.pas $(options)

calldate: init_ calldate/calldate.pas
	fpc calldate/calldate.pas $(options)

dir: init_ dir/dir.pas dir/listing.pas
	fpc dir/dir.pas -Fu$(include_path) $(options)

echo: init_ echo/echo.pas
	fpc echo/echo.pas $(options)

getvar: init_ getvar/getvar.pas
	fpc getvar/getvar.pas $(options) -Fu$(include_path)

mkdir: init_ mkdir/mkdir.pas
	fpc mkdir/mkdir.pas $(options) -Fu$(include_path)

presskey: init_ presskey/presskey.pas
	fpc presskey/presskey.pas $(options) -Fu$(include_path)

printf: init_ printf/printf.pas
	fpc printf/printf.pas $(options) -Fu$(include_path)

pwd: init_ pwd/pwd.pas
	fpc pwd/pwd.pas $(options) -Fu$(include_path)

rename: init_ rename/rename.pas
	fpc rename/rename.pas $(options) -Fu$(include_path)

rm: init_ rm/rm.pas
	fpc rm/rm.pas $(options) -Fu$(include_path)

touch: init_ touch/touch.pas
	fpc touch/touch.pas $(options) -Fu$(include_path)

# Build everything
all: init cat check_file_type calltime calldate dir echo getvar mkdir presskey printf rename rm

init_:
ifeq ($(do_clean), yes)
	$(MAKE) init
endif

# Clean
clean:
	$(RM) -rf build obj_out progs

# Initialize
init: clean
	mkdir build
	mkdir $(build_obj)
	mkdir $(build_progs)

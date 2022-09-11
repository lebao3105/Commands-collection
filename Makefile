# Program outputs
ifdef OS
	cat := build/cat.exe
	check_file_type := build/chk_type.exe
	calltime := build/calltime.exe
	echo := build/echo.exe
	dir := build/dir.exe
	find_content := build/find_content.exe
	getvar := build/getvar.exe
	mkdir := build/mkdir.exe
	presskey := build/presskey.exe
	printf := build/printf.exe
	pwd := build/pwd.exe
	rename := build/rename.exe
	rm_item := build/rm.exe
	touch := build/touch.exe
	build_obj := build\obj_out
	build_progs := build\progs
else
	cat := build/cat
	check_file_type := build/chk_type
	calltime := build/calltime
	dir := build/dir
	echo := build/echo
	find_content := build/find_content
	getvar := build/getvar
	mkdir := build/mkdir
	presskey := build/presskey
	printf := build/printf
	pwd := build/pwd
	rename := build/rename
	rm_item := build/rm
	touch := build/touch
	build_obj := build/obj_out
	build_progs := build/progs
endif

# Included units
include_path := include/

# Find rm/del on the system
ifdef OS
	rm_sys := del
else
	rm_sys := rm
endif

# Targets
cat: init_ cat/cat.pas
	fpc cat/cat.pas -o$(cat) -Fu$(include_path)

check_file_type: init_ check_file_type/chk_type.pas
	fpc check_file_type/chk_type.pas -o$(check_file_type) -Fu$(include_path)

calltime: init_ calltime/calltime.pas
	fpc calltime/calltime.pas -o$(calltime)

dir: init_ dir/dir.pas dir/listing.pas
	fpc dir/dir.pas -Fu$(include_path) -o$(dir)

echo: init_ echo/echo.pas
	fpc echo/echo.pas -o$(echo)

getvar: init_ getvar/getvar.pas
	fpc getvar/getvar.pas -o$(getvar) -Fu$(include_path)

mkdir: init_ mkdir/mkdir.pas
	fpc mkdir/mkdir.pas -o$(mkdir) -Fu$(include_path)

presskey: init_ presskey/presskey.pas
	fpc presskey/presskey.pas -o$(presskey) -Fu$(include_path)

printf: init_ printf/printf.pas
	fpc printf/printf.pas -o$(printf) -Fu$(include_path)

pwd: init_ pwd/pwd.pas
	fpc pwd/pwd.pas -o$(pwd) -Fu$(include_path)

rename: init_ rename/rename.pas
	fpc rename/rename.pas -o$(rename) -Fu$(include_path)

rm: init_ rm/rm.pas
	fpc rm/rm.pas -o$(rm_item) -Fu$(include_path)

touch: init_ touch/touch.pas
	fpc touch/touch.pas -o$(touch) -Fu$(include_path)

# Build everything
build_all: clean init cat check_file_type calltime dir echo getvar mkdir presskey printf rename rm
	mv -f build/*.o build/*.ppu $(build_obj)
ifdef OS
	mv build/*.exe $(build_progs)
else
	mv -f $(build_obj) .
# Solution from Mereghost (StackOverflow)
	find build/ -maxdepth 1 -type f -exec mv -f {} $(build_progs) \;
	mv -f obj_out build/
endif

init_:
ifeq ($(do_clean), yes)
	$(MAKE) clean
	$(MAKE) init
endif

# Clean
clean:
	rm -rf build obj_out progs

# Initialize
init: clean
	mkdir build
	mkdir $(build_obj)
	mkdir $(build_progs)

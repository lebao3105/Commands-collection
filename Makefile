# Program outputs
ifdef OS
	cat := build/cat.exe
	check_file_type := build/chk_type.exe
	cls := build/cls.exe
	echo := build/echo.exe
	dir := build/dir.exe
	find_content := build/find_content.exe
	getvar := build/getvar.exe
	help := build/help.exe
	mkdir := build/mkdir.exe
	move := build/move.exe
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
	cls := build/cls
	dir := build/dir
	echo := build/echo
	find_content := build/find_content
	getvar := build/getvar
	help := build/help
	mkdir := build/mkdir
	move := build/move
	printf := build/printf
	pwd := build/pwd
	rename := build/rename
	rm_item := build/rm
	touch := build/touch
	build_obj := build/obj_out
	build_progs := build/progs
endif

# Included units
include_path := rtl/

# Find rm/del on the system
ifdef OS
	rm_sys := del
else
	rm_sys := rm
endif

# Targets
.PHONY: build_all init cat check_file_type cls dir echo \
getvar mkdir printf rename $(RM) $(RM)dir clean
cat: init cat/cat.pas
	fpc cat/cat.pas -o$(cat) -Fu$(include_path)

check_file_type: init check_file_type/chk_type.pas
	fpc check_file_type/chk_type.pas -o$(check_file_type) -Fu$(include_path)

cls: init cls/cls.pas
	@echo Warning: this program only clear the current "window" - try to scroll up.
	fpc cls/cls.pas -o$(cls)

dir: init dir/dir.pas dir/listing.pas
	fpc dir/dir.pas -Fu$(include_path) -o$(dir)

echo: init echo/echo.pas
	fpc echo/echo.pas -o$(echo)

getvar: init getvar/getvar.pas
	fpc getvar/getvar.pas -o$(getvar) -Fu$(include_path)

mkdir: init mkdir/mkdir.pas
	fpc mkdir/mkdir.pas -o$(mkdir) -Fu$(include_path)

printf: init printf/printf.pas
	fpc printf/printf.pas -o$(printf) -Fu$(include_path)

pwd: init pwd/pwd.pas
	fpc pwd/pwd.pas -o$(pwd) -Fu$(include_path)

rename: init rename/rename.pas
	fpc rename/rename.pas -o$(rename) -Fu$(include_path)

rm: init rm/rm.pas
	fpc rm/rm.pas -o$(rm_item) -Fu$(include_path)

rmdir: init rm/rmdir.pas
	@echo This program is not working as expected. You cant use it now.

touch: init touch/touch.pas
	fpc touch/touch.pas -o$(touch) -Fu$(include_path)

# Build everything
build_all: clean init cat check_file_type cls dir echo getvar mkdir printf rename $(RM)  
	mv -f build/*.o build/*.ppu $(build_obj)
ifdef OS
	mv build/*.exe $(build_progs)
else
	mv -f $(build_obj) .
# Solution from Mereghost - StackOverflow
	find build/ -maxdepth 1 -type f -exec mv -f {} $(build_progs)
	mv -f obj_out build/
endif

# Clean
clean:
	rm -rf build obj_out progs

# Initialize
init: clean
	mkdir build
	mkdir $(build_obj)
	mkdir $(build_progs)

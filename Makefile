# Program outputs
ifdef OS
	cat := build/cat.exe
	check_file_type := build/chk_type.exe
	cls := build/cls.exe
	echo := build/echo.exe
	find_content := build/find_content.exe
	getvar := build/getvar.exe
	help := build/help.exe
	mkdir := build/mkdir.exe
	move := build/move.exe
	printf := build/printf.exe
	rename := build/rename.exe
	rm_item := build/rm.exe
	touch := build/touch.exe
	build_obj := build\obj_out
	build_progs := build\progs
else
	cat := build/cat
	check_file_type := build/chk_type
	cls := build/cls
	echo := build/echo
	find_content := build/find_content
	getvar := build/getvar
	help := build/help
	mkdir := build/mkdir
	move := build/move
	printf := build/printf
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
.PHONY: build_all init cat check_file_type cls date echo file_date find_content getvar help mkdir move printf rename $(RM) $(RM)dir clean
cat: init cat/cat.pas
	fpc cat/cat.pas -o$(cat) -Fu$(include_path)

check_file_type: init check_file_type/chk_type.pas
	fpc check_file_type/chk_type.pas -o$(check_file_type) -Fu$(include_path)

cls: init cls/cls.pas
	fpc cls/cls.pas -o$(cls)

echo: init echo/echo.pas
	fpc echo/echo.pas -o$(echo)

file_date: init file_date/file_date.pas
	@echo There are some problems in our code that block us from compiling this program.
	@echo You cant use it now. 

find_content: init find_content/find_content.pas
	@echo This program is not working as expected. You should not use it now.
	@echo But by default, you can use it.
	fpc find_content/find_content.pas -o$(find_content)

getvar: init getvar/getvar.pas
	fpc getvar/getvar.pas -o$(getvar) -Fu$(include_path)

help: init help/help.pas
	fpc help/help.pas -o$(help)

mkdir: init mkdir/mkdir.pas
	fpc mkdir/mkdir.pas -o$(mkdir) -Fu$(include_path)

move: init move/move.pas
	fpc move/move.pas -o$(move)

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
build_all: clean init cat check_file_type cls date echo find_content getvar help mkdir move printf rename $(RM)  
	mv -f build/*.o $(build_obj)
	mv -f $(build_obj) .
	mv -f build/* progs
	mv -f progs build
	mv -f obj_out $(build_obj)

# Clean
clean:
	rm -rf build obj_out progs

# Initialize
init:
	mkdir build
	mkdir progs
	mkdir $(build_obj)
	mkdir $(build_progs)

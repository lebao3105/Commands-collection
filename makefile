# Program outputs
ifdef OS
	cat := cat/cat.exe
	check_file_type := check_file_type/chk_type.exe
	cls := cls/cls.exe
	echo := echo/echo.exe
	find_content := find_content/find_content.exe
	getvar := getvar/getvar.exe
	help := help/help.exe
	mkdir := mkdir/mkdir.exe
	move := move/move.exe
	printf := printf/printf.exe
	rename := rename/rename.exe
	rm_item := rm/rm.exe
	touch := touch/touch.exe
else
	ifeq ($(shell uname), Linux)
		cat := cat/cat
		check_file_type := check_file_type/chk_type
		cls := cls/cls
		echo := echo/echo
		find_content := find_content/find_content
		getvar := getvar/getvar
		help := help/help
		mkdir := mkdir/mkdir
		move := move/move
		printf := printf/printf
		rename := rename/rename
		rm_item := rm/rm
		touch := touch/touch
	endif
endif

# Rm / del command
ifdef OS
	RM := rm 
else
	ifeq ($(shell uname), Linux)
		RM := rm 
	endif
endif

# Included units
include_path := rtl/

# Targets
.PHONY: all cat check_file_type cls date echo file_date find_content getvar help mkdir move printf rename $(RM) $(RM)dir
cat: cat/cat.pas
	fpc cat/cat.pas -o$(cat) -Fu$(include_path)

check_file_type: check_file_type/chk_type.pas
	fpc check_file_type/chk_type.pas -o$(check_file_type) -Fu$(include_path)

cls: cls/cls.pas
	fpc cls/cls.pas -o$(cls)

date: date/date.pas
	echo This program is not working as expected. You cant use it now.

echo: echo/echo.pas
	fpc echo/echo.pas -o$(echo)

file_date: file_date/file_date.pas
	echo There are some problems that block us from compiling this program.
	echo You cant use it now. Exiting.

find_content: find_content/find_content.pas
	echo This program is not working as expected. You should not use it now.
	echo But by default, you can use it.
	fpc find_content/find_content.pas -o$(find_content)

getvar: getvar/getvar.pas
	fpc getvar/getvar.pas -o$(getvar) -Fu$(include_path)

help: help/help.pas
	fpc help/help.pas -o$(help)

mkdir: mkdir/mkdir.pas
	fpc mkdir/mkdir.pas -o$(mkdir) -Fu$(include_path)

move: move/move.pas
	fpc move/move.pas -o$(move)

printf: printf/printf.pas
	fpc printf/printf.pas -o$(printf) -Fu$(include_path)

pwd: pwd/pwd.pas
	fpc pwd/pwd.pas -o$(pwd) -Fu$(include_path)

rename: rename/rename.pas
	fpc rename/rename.pas -o$(rename) -Fu$(include_path)

rm: rm/rm.pas
	fpc rm/rm.pas -o$(rm_item) -Fu$(include_path)

rmdir: rm/rmdir.pas
	echo This program is not working as expected. You cant use it now.

touch: touch/touch.pas
	fpc touch/touch.pas -o$(touch) -Fu$(include_path)

# Build everything
all: cat check_file_type cls date echo file_date find_content getvar help mkdir move printf rename $(RM) $(RM)dir

# Clean
clean:
	$(RM) -f $(cat) $(check_file_type) $(cls) $(date) $(echo) $(find_content) $(*/*.o)
	$(RM) -f $(getvar) $(help) $(mkdir) $(move) $(printf) $(pwd) $(rename) $(rm_item) $(touch)
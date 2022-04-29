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
else
	ifeq ($(shell uname), Linux)
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
	endif
endif

# Included units and installation path (not /usr/bin!) in Linux
include_path := rtl/
PATH_TEMPO := $(HOME)/.local/bin

# Targets
.PHONY: build_all cat check_file_type cls date echo file_date find_content getvar help mkdir move printf rename $(RM) $(RM)dir install install_systemwide uninstall clean
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
	@echo There are some problems in our code that block us from compiling this program.
	@echo You cant use it now. 

find_content: find_content/find_content.pas
	@echo This program is not working as expected. You should not use it now.
	@echo But by default, you can use it.
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
	@echo This program is not working as expected. You cant use it now.

touch: touch/touch.pas
	fpc touch/touch.pas -o$(touch) -Fu$(include_path)

# Build everything
build_all: cat check_file_type cls date echo find_content getvar help mkdir move printf rename $(RM) 
	mv -rf build $(PATH)

# Uninstall
uninstall:
	ifdef OS
		rm -f %USERPROFILE%\.cmds_collection\bin
		@echo The uninstallation now should be completed. Remove %USERPROFILE%\bin from Environment Variables window.
	else
		ifeq  ($(shell uname), Linux)
			rm -rf ~/bin
			bash export $PATH_TEMP=$(PATH_TEMPO)
			sed -i 's/$PATH_TEMP/''/g' ~/.bashrc
			source ~/.bashrc
			@echo The uninstallation now should be completed.
		endif
	endif
	
# Even install

## This will install our programs to $HOME/.local/bin, which is set in $(PATH) (NOT system's path) variable.
## Also add $(PATH) to the $PATH (here's the system's one) by print a line to ~/.bashrc
install: build_all uninstall
	cp -r build $(PATH_TEMPO)
	@echo Done.

## This target will install entrie Commands-Collection project to /usr/bin folder.
## Of course we will need to use 'sudo'.
install_systemwide: build_all uninstall
	cp -r build /usr/bin
	@echo Done.
	
# Clean
clean:
	rm -rf build 

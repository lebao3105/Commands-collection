#!/usr/bin/env bash
set -e

echo "Building for $1..."

pushd ../include
gcc custcustapp.c -c -Wall -fpic -o custcustc.o \
	-I. -I../src/dir -DPROG_CONFIG_PATH=\"../src/$1/config.h\"
gcc -shared -o ../src/$1/libcustcustc.so custcustc.o

popd
pushd ../src
fpc $1/$1.pp -gl \
	-Mfpc -Sa -Si -Sm -Sc -Sx -Co -CO -Cr -CR \
	-dbg:=begin -ded:=end -dretn:=procedure \
	-dfn:=function -dlong:=longint -dulong:=longword \
	-dint:=integer -dbool:=boolean -dreturn:=exit \
	-Fu../src -Fu../include -Fi../src -Fi../include \
	-Fl../include -FE../include

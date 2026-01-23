#define PROJECT_VERSION "1.1.0alpha"
#define PROJECT_NAME "uptime"
#define PROJECT_DESC "Displays system uptime"

#include "../../include/base.h"
#include "i18n.h"

GET_DEFINITION_VAL(PROCESSOR_TYPE)
GET_DEFINITION_VAL(HARDWARE_PLAT)
GET_DEFINITION_VAL(UNKNOWN)
GET_DEFINITION_VAL(OPERATING_SYSTEM)
GET_DEFINITION_VAL(UNAME_FAILED)
GET_DEFINITION_VAL(KERNEL_NAME)
GET_DEFINITION_VAL(KERNEL_RELEASE)
GET_DEFINITION_VAL(KERNEL_VERSION)
GET_DEFINITION_VAL(MACHINE_HWNAME)
GET_DEFINITION_VAL(NETWORK_NODENAME)

#define CUSTCUSTC_ARGA \
{ \
	{"all",       			0, 0, 'a'}, \
	{"formatted",			0, 0, 'f'}, \
	{"kernel-name",     	0, 0, 's'}, \
	{"kernel-release",    	0, 0, 'r'}, \
	{"kernel-version",		0, 0, 'v'}, \
	{"machine",				0, 0, 'm'}, \
	{"nodename",			0, 0, 'n'}, \
	{"processor",			0, 0, 'p'}, \
	{"hardware-platform",   0, 0, 'i'}, \
	{"operating-system",    0, 0, 'o'},

#define PROGRAM_HELP \
	CREATE_ARG_HELP("a", "all", ALL_DES) \
	CREATE_ARG_HELP("f", "formatted", FORMATTED_DES) \
	CREATE_ARG_HELP("s", "kernel-name", KERN_NAME_DES) \
	CREATE_ARG_HELP("r", "kernel-release", KERN_REL_DES) \
	CREATE_ARG_HELP("v", "kernel-version", KERN_VER_DES) \
	CREATE_ARG_HELP("m", "machine", MACHINE_DES) \
	CREATE_ARG_HELP("n", "nodename", NODENAME_DES) \
	CREATE_ARG_HELP("p", "processor", PROCESSOR_DES) \
	CREATE_ARG_HELP("i", "hardware-platform", HARDWARE_DES) \
	CREATE_ARG_HELP("o", "operating-system", OPERATING_DES)

#define PROGRAM_BONUS_HELP \
	"With nothing else provided, -s will be omitted.\n" \
	"-f must be provided before any other flags, else you " \
	"will either geta mixed output, or no -f effect at all.\n" \
	"-o output may differ from GNU uname's output due to the " \
	"underlying implementation.\n Check the following site for all identifies from GNU:" \
	"https://github.com/coreutils/gnulib/blob/master/m4/host-os.m4"

#define PROGRAM_SHORTOPTS "rsp"

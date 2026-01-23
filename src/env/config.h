#define PROJECT_VERSION "1.1.0alpha"
#define PROJECT_NAME "env"
#define PROJECT_DESC "(Un)set environment variables for a will-be-spawned process"

#include "../../include/base.h"
#include "i18n.h"

GET_DEFINITION_VAL(NO_PROG_SPECIFIED)
GET_DEFINITION_VAL(EXE_NOT_FOUND)

#define CUSTCUSTC_ARGA \
{ \
	{"get", 			1, 0, 'g'}, \
	{"set", 			1, 0, 's'}, \
	{"unset", 			1, 0, 'u'}, \
	{"clean", 			0, 0, 'c'},

#define PROGRAM_HELP \
	CREATE_ARG_VAL_HELP("g", "get", "VAR", GET_DES) \
	CREATE_ARG_VAL_HELP("s", "set", "VAR=VAL", SET_DES) \
	CREATE_ARG_VAL_HELP("u", "unset", "VAR", UNSET_DES) \
	CREATE_ARG_HELP("c", "clean", CLEAN_DES)

#define PROGRAM_BONUS_HELP \
	"If no argument is specified, all existing environment variables will be printed.\n" \
	"Otherwise, a program must be specified." \
	"Unless otherwise specified via -c, all existing variables will not be removed for the upcoming process."

#define PROGRAM_SHORTOPTS "g:s:u:c"

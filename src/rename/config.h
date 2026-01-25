#define PROJECT_NAME "rename"
#define PROJECT_DESC "Renames files and folders."

#include "../../include/base.h"
#include "i18n.h"

GET_DEFINITION_VAL(RENAMED_TO)
GET_DEFINITION_VAL(RENAME_FAIL)
GET_DEFINITION_VAL(CONFIRM)

#define CUSTCUSTC_ARGA \
{ \
	{"symlink", 			0, 0, 's'}, \
	{"dry-run", 			0, 0, 'd'}, \
	{"bulk", 				0, 0, 'b'}, \
	{"regex", 				0, 0, 'r'}, \
	{"no-overrides", 		0, 0, 'o'}, \
	{"interactive", 		0, 0, 'i'}, \
	{"last", 				0, 0, 'l'}, \
	{"keep-attributes", 	0, 0, 'k'}, \
	{"opposites", 			0, 0, 'p'}, \
	VERBOSE_ARG,

#define PROGRAM_HELP \
	CREATE_ARG_HELP("s", "symlink", SYMLINK_DES) \
	CREATE_ARG_HELP("d", "dry-run", DRY_RUN_DES) \
	CREATE_ARG_HELP("b", "bulk", BULK_DES) \
	CREATE_ARG_HELP("r", "regex", REGEX_DES) \
	CREATE_ARG_HELP("o", "no-overrides", IGN_EXISTS_DES) \
	CREATE_ARG_HELP("i", "interactive", INTERACTIVE_DES) \
	CREATE_ARG_HELP("l", "last", LAST_OCC_DES) \
	CREATE_ARG_HELP("k", "keep-attributes", KEEP_ATTRS_DES) \
	CREATE_ARG_HELP("p", "opposites", OPPOSITES_DES) \
	VERBOSEARG_HELP

#define PROGRAM_BONUS_HELP \
	"-b matches all occurences of the pattern, automatically omitting -r.\n" \
	"-p matches all occurences that do NOT match the specified pattern / files.\n" \
	"-s follows symlinks, for both target and destination.\n"

#define PROGRAM_SHORTOPTS "sdbroilkpv"

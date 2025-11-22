#define PROJECT_VERSION "1.1.0alpha"
#define PROJECT_NAME "dir"
#define PROJECT_DESC "Iterates directories"

#include "../../include/base.h"
#include "i18n/dir.h"

GET_DEFINITION_VAL(PERMISSION_DENIED)
GET_DEFINITION_VAL(STAT_FAILED)
GET_DEFINITION_VAL(OPEN_DIR_FAILED)
GET_DEFINITION_VAL(FILES_COUNT)
GET_DEFINITION_VAL(DIRS_COUNT)
GET_DEFINITION_VAL(IGNORED_COUNT)
GET_DEFINITION_VAL(STATFAIL_COUNT)
GET_DEFINITION_VAL(FREE_SPACE)

#define CUSTCUSTC_ARGA \
{ \
	{"list",           0, 0, 'l'}, \
	{"all",            0, 0, 'a'}, \
	{"color",          0, 0, 'c'}, \
	{"directory",      0, 0, 'd'}, \
	{"ignore",         1, 0, 'i'}, \
	{"ignore-backups", 0, 0, 'B'}, \
	{"recursive",      0, 0, 'R'}, \
	{"win-fmt",        0, 0, 'w'}, \
	{"gnu-fmt",        0, 0, 'u'}, \
	{"cmc-fmt",        0, 0, 'm'}, \
	ARGA_SUFFIX

#define PROGRAM_HELP \
	CREATE_ARG_HELP("l", "list", LIST_DES) \
	CREATE_ARG_HELP("a", "all", ALL_DES) \
	CREATE_ARG_HELP("c", "color", COLOR_DES) \
	CREATE_ARG_HELP("d", "directory", DIR_ONLY_DES) \
	CREATE_ARG_VAL_HELP("i", "ignore", "[PATTERN]", IGNORE_DES) \
	CREATE_ARG_HELP("B", "ignore-backups", IGNORE_BCK_DES) \
	CREATE_ARG_HELP("R", "recursive", RECURSIVE_DES) \
	CREATE_ARG_HELP("w", "win-fmt", WIN_FMT_DES) \
	CREATE_ARG_HELP("u", "gnu-fmt", GNU_FMT_DES) \
	CREATE_ARG_HELP("m", "cmc-fmt", CC_FMT_DES) \
	HELP_SUFFIX

#define PROGRAM_BONUS_HELP \
	"Ignore pattern is a single regular expression, which can be modified by " \
	PROJECT_NAME " during its runtime.\n" \
	"If -B is used, pattern matching ~ and .bak suffixes will be appended.\n" \
	"If -a is NOT used, pattern matching . (literally a dot) prefix will be appended.\n" \
	"By default, the ignore pattern is case-INsensitive. Currently you can't change that.\n" \
	"Comments and line breaks are allowed like this:\n" \
	"( # this is a comment\n" \
	"abc\n" \
	"def\n" \
	") # done \n"


#define PROGRAM_SHORTOPTS "lacdi:BRwumhV"

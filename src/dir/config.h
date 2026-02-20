#define PROJECT_NAME "dir"
#define PROJECT_DESC "Iterates directories"

#include "../../include/base.h"
#include "../../include/custcustc.h"
#include "i18n.h"

#define CUSTCUSTC_ARGA \
{ \
	{"list",           0, 0, 'l'}, \
	{"all",            0, 0, 'a'}, \
	{"color",          0, 0, 'c'}, \
	{"directory",      0, 0, 'd'}, \
	{"ignore",         1, 0, 'i'}, \
	{"ignore-backups", 0, 0, 'B'}, \
	{"recursive",      0, 0, 'R'},

#define PROGRAM_HELP \
	CREATE_ARG_HELP("l", "list", LIST_DES) \
	CREATE_ARG_HELP("a", "all", ALL_DES) \
	CREATE_ARG_HELP("c", "color", COLOR_DES) \
	CREATE_ARG_HELP("d", "directory", DIR_ONLY_DES) \
	CREATE_ARG_HELP("B", "ignore-backups", IGNORE_BCK_DES) \
	CREATE_ARG_HELP("R", "recursive", RECURSIVE_DES) \
	CREATE_ARG_VAL_HELP("i", "ignore", "PATTERN", IGNORE_DES)

#define PROGRAM_BONUS_HELP \
	"Ignore pattern is a single regular expression, which can be modified by " \
	PROJECT_NAME " before iterating directories. This is used to match names, not owner name/group nor permissions.\n" \
	"If -B is used, entities with ~ or .bak suffix will be ignored.\n" \
	"If -a is NOT used, entities with . (a literal dot) prefix will be ignored.\n" \
	"By default, the ignore pattern is case-INsensitive. Currently you can't change that.\n" \
	\
	PARAGRAPH \
	"Comments and line breaks are allowed like this:\n" \
	"( # this is a comment\n" \
	"abc\n" \
	"def\n" \
	") # done \n" \
    PARAGRAPH \
    "DIR_CONFPATH environment variable points to where dir settings are stored.\n" \
    "DIR_PRESET environment variable points to the preset that dir will use (gnu, win, ccd).\n" \
    "Check dir(5) manual page for more informations.\n"

#define PROGRAM_SHORTOPTS "lacdBRi:"

#define PROJECT_VERSION "1.1.0alpha"
#define PROJECT_NAME "calltime"
#define PROJECT_DESC "Returns the current time and date, in style."

#define OPT_DEFAULT_FORMAT "dddd mmmm dd yyyy tt"

#define PROGRAM_BONUS_HELP \
	"Consult https://www.freepascal.org/docs-html/rtl/sysutils/formatchars.html " \
	"for more information about time format strings."

#include "../../include/base.h"

GET_DEFINITION_VAL(OPT_DEFAULT_FORMAT)

#define CUSTCUSTC_ARGA \
{ \
	{"format", 1, 0, 'f'}, \
	ARGA_SUFFIX

#define PROGRAM_HELP \
	CREATE_ARG_VAL_WITH_DEF_HELP( \
		"f", "format", "[FORMAT]", OPT_DEFAULT_FORMAT, "Time format" \
	) \
	HELP_SUFFIX

#define PROGRAM_SHORTOPTS "hVf:"

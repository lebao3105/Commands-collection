#define PROJECT_VERSION "1.1.0alpha"
#define PROJECT_NAME "uptime"
#define PROJECT_DESC "Displays system uptime"

#include "../../include/base.h"
#include "i18n.h"

GET_DEFINITION_VAL(CURRENT_TIME)
GET_DEFINITION_VAL(UPTIME_COUNT)
GET_DEFINITION_VAL(UPTIME_DAYS)
GET_DEFINITION_VAL(UPTIME_HOURS)
GET_DEFINITION_VAL(UPTIME_MINUTES)
GET_DEFINITION_VAL(UPTIME_SECONDS)
GET_DEFINITION_VAL(USER_COUNT)
GET_DEFINITION_VAL(LOAD_AVG)

#define CUSTCUSTC_ARGA \
{ \
	{"raw",       0, 0, 'r'}, \
	{"since",     0, 0, 's'}, \
	{"pretty",    0, 0, 'p'},

#define PROGRAM_HELP \
	CREATE_ARG_HELP("r", "raw", RAW_DES) \
	CREATE_ARG_HELP("s", "since", SINCE_DES) \
	CREATE_ARG_HELP("p", "pretty", PRETTY_DES)

#define PROGRAM_SHORTOPTS "rsp"

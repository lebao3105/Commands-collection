#define PROJECT_NAME "uptime"
#define PROJECT_DESC "Displays system uptime"

#include "../../include/base.h"
#include "../../include/custcustc.h"
#include "i18n.h"

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

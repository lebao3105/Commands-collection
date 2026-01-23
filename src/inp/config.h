#define PROJECT_VERSION "1.1.0alpha"
#define PROJECT_NAME "inp"
#define PROJECT_DESC "Asks for user input."

#include "../../include/base.h"
#include "i18n.h"

GET_DEFINITION_VAL(PRESS_ANY_KEY)

#define CUSTCUSTC_ARGA \
{ \
	{"message",				1, 0, 'm'}, \
	{"hide-input",			0, 0, 't'}, \
	{"require-enter",		0, 0, 'e'}, \
	{"require-chars",		1, 0, 'k'}, \
	{"loop",				0, 0, 'l'}, \
	{"show-availables",		0, 0, 'o'}, \
	{"case-sensitive",		0, 0, 's'},

#define PROGRAM_HELP \
	CREATE_ARG_VAL_HELP("m", "message", "MESSAGE", MSG_DES) \
	CREATE_ARG_HELP("t", "hide-input", HIDEOKOJIMA_DES) \
	CREATE_ARG_HELP("e", "require-enter", REQENTER_DES) \
	CREATE_ARG_VAL_HELP("k", "require-chars", "CHARS", REQCHAR_DES) \
	CREATE_ARG_HELP("l", "loop", LOOP_DES) \
	CREATE_ARG_HELP("o", "show-availables", SHOWAVAI_DES) \
	CREATE_ARG_HELP("s", "case-sensitive", CASESENS_DES)

#define PROGRAM_BONUS_HELP \
	"-o will show characters from -k inside squared brackets, e.g [ynYn].\n" \
	"If no arguments are provided, the program will simply ask for a key press, quits with exit code 0.\n" \
	"Otherwise will quit with the exit code set to the ASCII value of the input character."

#define PROGRAM_SHORTOPTS "m:tek:los"

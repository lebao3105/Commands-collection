#pragma once

#ifndef CC_VERSION
#define CC_VERSION "1.1.0alpha"
#endif

#include "termcolor.h"

/*
 * Program-argument macros.
 * You know what we gonna use to parse flags and such: GetOpt.
 * CUSTCUSTC_ARGA (ARGA = ARGuments Array) definition is used
 * 		to define the program's argument array.
 * If you want to define this, make sure:
 * 1. ARGA must be ended with ARGA_SUFFIX
 * 2. VERBOSE_ARG exists below for verbosity flag. No need to manually type one.
 * 3. Do NOT end ARGA with a close bracket (aka })!
 * 4. Update PROGRAM_SHORTOPTS to the combination of your short flags.
 * 	  Not all are required.
 * Help & Version are always included.
 */

#define HELP_ARG {"help", 0, 0, 'h'}
#define VERS_ARG {"version", 0, 0, 'V'}
#define VERBOSE_ARG {"verbose", 0, 0, 'v'}
#define NULL_ARG {0, 0, 0, 0}

/* Must-have components for program's GetOpt list */
#define ARGA_SUFFIX \
	HELP_ARG, \
	VERS_ARG, \
	NULL_ARG \
}

/*
 * Macros born to create PROGRAM_HELP definition in compile time;-)
 * CREATE_ARG_HELP : Basic flag
 * CREATE_ARG_VAL_HELP : Basic flag with a required value
 * CREATE_ARG_VAL_WITH_DEF_HELP : CREATE_ARG_VAL_HELP+a default value
 * Currently this requires your flag to have both short and long forms.
 * I will write more macros later.
 * And like ARGA, the help string must have descriptions for --help and --version,
 * respectively available via HELPARG_HELP and VERSIONARG_HELP.
 * Just append HELP_SUFFIX macro to the end and you're done.
 */

#define CREATE_ARG_HELP(short, long, help) \
        ANSI_CODE_WHITE ANSI_CODE_BOLD \
		"--" long " -" short "\n" \
        ANSI_CODE_RESET \
		"\t" help "\n"

#define CREATE_ARG_VAL_HELP(short, long, val_name, help) \
        ANSI_CODE_WHITE ANSI_CODE_BOLD \
		"--" long " -" short " [" val_name "]\n" \
        ANSI_CODE_RESET \
		"\t" help "\n"

#define CREATE_ARG_VAL_WITH_DEF_HELP(short, long, val_name, val_def, help) \
        ANSI_CODE_WHITE ANSI_CODE_BOLD \
		"--" long " -" short " [" val_name "]\n" \
        ANSI_CODE_RESET \
		"\t" help "\n" \
		"\tDefaults to " val_def "\n"

#define HELPARG_HELP \
	CREATE_ARG_HELP("h", "help", "Display this help message")

#define VERSIONARG_HELP \
	CREATE_ARG_HELP("V", "version", "Display the program's version")

#define VERBOSEARG_HELP \
	CREATE_ARG_HELP("v", "verbose", "Enable verbose mode")

#define HELP_SUFFIX \
	HELPARG_HELP \
	VERSIONARG_HELP

#define PARAGRAPH "\n"

void custcustapp_start(int argc, char** argv);
void custcustapp_showhelp(const int to_stdout);
void custcustapp_deinitialize();
char* custcustapp_get_opt_arg();
int custcustapp_get_opt_ind();

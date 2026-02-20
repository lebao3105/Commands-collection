#ifndef PROG_CONFIG_PATH
#error "No idea what to build for - PROG_CONFIG_PATH must be set"
#else
#include PROG_CONFIG_PATH

#ifndef PROJECT_NAME
#error "PROJECT_NAME must be defined"
#endif

#ifndef PROJECT_DESC
#error "PROJECT_DESC must be defined"
#endif

#if !defined(PROGRAM_SHORTOPTS) && defined(CUSTCUSTC_ARGA)
#error "CUSTCUSTC_ARGA has been defined, but you forgot to define PROGRAM_SHORTOPTS"
#endif

#if defined(PROGRAM_SHORTOPTS) && !defined(CUSTCUSTC_ARGA)
#error "PROGRAM_SHORTOPTS has been defined, but you forgot to define CUSTCUSTC_ARGA"
#endif

#ifndef CUSTCUSTC_ARGA
#define CUSTCUSTC_ARGA { ARGA_SUFFIX
#endif

#ifndef PROGRAM_HELP
#warning "PROGRAM_HELP is not defined. Really?"
#define PROGRAM_HELP
#endif

#endif

#include "../include/base.h"
#include "../include/custcustc.h"

#include <assert.h> /* assertions */
#include <stdio.h> /* FILE, fprintf, fputs */
#include <stdlib.h> /* EXIT_*, NULL, free, exit, malloc */
#include <getopt.h> /* optind, opterr, optopt, option struct, getopt_long */

typedef void (*OptionHandler)(const char);
OptionHandler option_handler = 0;

extern void pagedPrintP(const char* data, int useStdErr);

// char **NonOptions = NULL;
static struct option options[] = CUSTCUSTC_ARGA ARGA_SUFFIX;

void custcustapp_start(int argc, char** argv)
{
    atexit(custcustapp_deinitialize);
    assert(option_handler != 0);

    int c = 0;
    int option_index = 0;

    while (1)
    {
        c = getopt_long(argc, argv, PROGRAM_SHORTOPTS "hV",
                        options, &option_index);
        if (c == -1)
            break;

        switch (c) {
        case 'h':
            custcustapp_showhelp(1);
            exit(EXIT_SUCCESS);
            break;

        case 'V':
            fprintf(stdout, _("Commands-Collection (CC) version %s\n"), CC_VERSION);
            break;

        case '?':
	       	custcustapp_showhelp(0);
			exit(EXIT_FAILURE);
            break;

        default:
            option_handler(c);
            break;
        }
    }

    // NonOptions: will be populated later in custcustapp.pp
}

void custcustapp_showhelp(const int to_stdout)
{
    pagedPrintP(
        ANSI_CODE_RED ANSI_CODE_BOLD
        PROJECT_NAME " [flags] [flag values] [...]\n"
        ANSI_CODE_GREEN
        PROJECT_DESC "\n"
        ANSI_CODE_RESET
        PROGRAM_HELP
        HELP_SUFFIX "\n"
        #ifdef PROGRAM_BONUS_HELP
        PROGRAM_BONUS_HELP "\n"
        #endif
        ANSI_CODE_RESET
        ,
        to_stdout == 1
    );
}

void custcustapp_deinitialize()
{
	// free(NonOptions);
}

char* custcustapp_get_opt_arg() {
	return optarg;
}

int custcustapp_get_opt_ind() {
	return optind;
}

#if !defined(PROG_CONFIG_PATH) && !defined(NO_CONFIG)
#error "No idea what to build - PROG_CONFIG_PATH or NO_CONFIG must be set"
#endif

#if defined PROG_CONFIG_PATH && !defined(NO_CONFIG)

#define HAS_CONFIG
#include PROG_CONFIG_PATH

#ifndef PROJECT_DESC
#error "PROJECT_DESC must be defined"
#endif

#ifndef PROGRAM_SHORTOPTS
	#ifdef CUSTCUSTC_ARGA
	#error "CUSTCUSTC_ARGA has been defined, but you forgot to define PROGRAM_SHORTOPTS"
	#endif

	#define PROGRAM_SHORTOPTS "hV"
#endif

#ifndef CUSTCUSTC_ARGA
#define CUSTCUSTC_ARGA { ARGA_SUFFIX
#endif

#ifndef PROGRAM_HELP
#define PROGRAM_HELP HELP_SUFFIX
#endif

#endif

#include "custcustapp.h"
#include "base.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h> /* optind, opterr, optopt, option struct, getopt_long */

typedef void (*OptionHandler)(const char);
OptionHandler option_handler = 0;

char** NonOptions = NULL;
static struct option options[] = CUSTCUSTC_ARGA;

void custcustapp_start(int argc, char** argv)
{
    atexit(custcustapp_deinitialize);
    assert(option_handler != 0);

    int c = 0;
    int option_index = 0;

    while (1)
    {
        c = getopt_long(argc, argv, PROGRAM_SHORTOPTS,
                        options, &option_index);
        if (c == -1)
            break;

        switch (c) {
        case 'h':
            custcustapp_showhelp();
            exit(EXIT_SUCCESS);
            break;

        case 'V':
            fprintf(stdout, "Project version: %s\n", PROJECT_VERSION);
            fprintf(stdout, "Commands-Collection (CC) version %s\n", CC_VERSION);
            break;

        case '?':
            break;

        default:
            option_handler(c);
            break;
        }
    }

    // if (optind < argc) {
    // 	NonOptions = malloc(sizeof(char*) * (argc - optind));
    // 	if (!NonOptions) {
    // 		fprintf(stderr, "Failed to allocate memory for non-option arguments.\n");
    // 		exit(EXIT_FAILURE);
    // 	}
    // 	NonOptions[argc - optind] = NULL;
    //     while (optind < argc)
	   //      NonOptions[argc - optind] = argv[optind++];
    // }
}

void custcustapp_showhelp() {
    printf(PROJECT_NAME " [flags] [flag values] [stuff]\n"
    	   PROJECT_DESC "\n\n"
           PROGRAM_HELP "\n");

    // printf("Copyright (C) 2025 Commands-Collection team.\n");
    // printf("This program is licensed under the GNU General Public License version 3.\n\n");

#ifdef PROGRAM_BONUS_HELP
   	fprintf(stdout, "%s\n", PROGRAM_BONUS_HELP);
#endif
}

void custcustapp_deinitialize() {
}

char* custcustapp_get_opt_arg() {
	return optarg;
}

int custcustapp_get_opt_ind() {
	return optind;
}

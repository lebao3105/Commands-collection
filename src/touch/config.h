#pragma once

#define PROJECT_NAME "touch"
#define PROJECT_DESC "Creates files and directories"

#include "../../include/base.h"
#include "../../include/custcustc.h"
#include "i18n.h"

#define CUSTCUSTC_ARGA \
{ \
    {"parent",              0, 0, 'p'}, \
    {"create-dirs",         0, 0, 'd'}, \
    VERBOSE_ARG,

#define PROGRAM_HELP \
    CREATE_ARG_HELP("p", "parent", PARENT_DES) \
    CREATE_ARG_HELP("d", "create-dirs", DIRS_DES) \
    VERBOSEARG_HELP

#define PROGRAM_SHORTOPTS "pv"

{$define HAS_BONUS_HELP}

resourcestring
    GET_DES = 'Get environment variables';
    SET_DES = 'Set environment variables';
    UNSET_DES = 'Unset environment variables';
    CLEAN_DES = 'Clean environment, containing only variables from -s';

    PROGRAM_DESC = 'Launch processes with specified (and maybe modified) environment variables.';
    PROGRAM_BONUS_HELP =
        'If no argument is specified, all existing environment variables will be printed.' + LineEnding +
        'Otherwise, a program must be specified.' + LineEnding +
        'Unless otherwise specified via -c, all existing variables will not be removed for the upcoming process.';

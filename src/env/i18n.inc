resourcestring
    GET_DES = 'Get environment variables';
    SET_DES = 'Set environment variables';
    UNSET_DES = 'Unset environment variables';
    CLEAN_DES = 'Clean environment, containing only variables from -s';

    PROGRAM_DESC = 'Launch processes with specified (and maybe modified) environment variables.';
    PROGRAM_BONUS_HELP =
        'If no argument is specified, all existing environment variables will be printed.' + CRNL +
        'Otherwise, a program must be specified.' + CRNL +
        'Unless otherwise specified via -c, all existing variables will not be removed for the upcoming process.';

	NoProgSpecified = 'No program was specified. This program will not set ' +
	                  'variables for your current shell/program instance and even user/system-wide.';
	ExeNotFound = '%s not found - any typo here?';
	ProcessExit = 'Process exited with the following message: %s';

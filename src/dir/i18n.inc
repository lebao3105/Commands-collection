resourcestring
{$ifdef NEED_PROGRAM_HELP}
{$define HAS_BONUS_HELP}
    LIST_DES = 'Show the output as a list';
    ALL_DES = 'Show everything, even hidden entries. Has exceptions.';
    COLOR_DES = 'Colorize the output';
    DIR_ONLY_DES = 'Only show directories';
    IGNORE_DES = 'Use regular expression to skip entities';
    IGNORE_BCK_DES = 'Ignore entities whose name end with ~ or .bak';
    RECURSIVE_DES = 'List stuff, recursively';

    PROGRAM_DESC = 'Iterate directories.';
    PROGRAM_BONUS_HELP =
        'Ignore pattern is a regular expression which is used to filter out stuff using their name.' + CRNL +
        'If -B is used, entities with ~ or .bak suffix will be ignored.' + CRNL +
        'If -a is NOT used, entities with . (a literal dot) prefix will be ignored.' + CRNL +
        'By default, the ignore pattern is case-INsensitive. Currently you can''t change that' + CRNL +
        CRNL +
        'Comments and line breaks are allowed like this:' + CRNL +
        '( # this is a comment' + CRNL +
        'abc' + CRNL +
        'def' + CRNL +
        ') # done ' + CRNL +
        CRNL +
        'DIR_CONFPATH environment variable points to where dir settings are stored.' + CRNL +
        'DIR_PRESET environment variable points to the preset that dir will use (gnu, win, ccd).' + CRNL +
        'Check dir(5) manual page for more informations.';
{$else}
	// Fails
	STAT_FAILED 	  = 'failed to stat %s: %s';
	PERMISSION_DENIED = '%s: permission denied';
	OPEN_DIR_FAILED   = 'failed to open directory %s: %s';

	// Counts
	FILES_COUNT       = '%u file(s)';
	DIRS_COUNT        = '%u dir(s)';
	IGNORED_COUNT     = '%u ignored';
	STATFAIL_COUNT    = '%u failed to stat()';
	FREE_SPACE 	      = '%s free';

    // More
    INVALID_COLUMN    = '%s: unknown column type';
{$endif}
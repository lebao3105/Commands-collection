{$define HAS_BONUS_HELP}

resourcestring
    LIST_DES = 'Show the output as a list';
    ALL_DES = 'Show everything, even hidden entries. Has exceptions.';
    COLOR_DES = 'Colorize the output';
    DIR_ONLY_DES = 'Only show directories';
    IGNORE_DES = 'Use regular expression to skip entities';
    IGNORE_BCK_DES = 'Ignore entities whose name end with ~ or .bak';
    RECURSIVE_DES = 'List stuff, recursively';

    PROGRAM_DESC = 'Iterate directories.';
    PROGRAM_BONUS_HELP =
        'Ignore pattern is a regular expression which is used to filter out stuff using their name.' + LineEnding +
        'If -B is used, entities with ~ or .bak suffix will be ignored.' + LineEnding +
        'If -a is NOT used, entities with . (a literal dot) prefix will be ignored.' + LineEnding +
        'By default, the ignore pattern is case-INsensitive. Currently you can''t change that' + LineEnding +
        LineEnding +
        'Comments and line breaks are allowed like this:' + LineEnding +
        '( # this is a comment' + LineEnding +
        'abc' + LineEnding +
        'def' + LineEnding +
        ') # done ' + LineEnding +
        LineEnding +
        'DIR_CONFPATH environment variable points to where dir settings are stored.' + LineEnding +
        'DIR_PRESET environment variable points to the preset that dir will use (gnu, win, ccd).' + LineEnding +
        'Check dir(5) manual page for more informations.';

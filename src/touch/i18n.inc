resourcestring
{$ifdef NEED_PROGRAM_HELP}
    PARENT_DES               = 'Create parent directories if needed';
    DIRS_DES                 = 'Create directories ONLY';
    PROGRAM_DESC             = 'Creates files and directories';
{$else}
    NOTHING_TO_CREATE        = 'Nothing to create.';
    CREATING_STUFF           = 'Creating %s...';
    CREATED_STUFF            = 'Created %s.';
    FAILED_TO_CREATE         = 'Failed to create %s: %s';
    ALREADY_EXISTS           = '%s already exists';
{$endif}

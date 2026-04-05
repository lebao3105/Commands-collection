resourcestring
{$ifdef NEED_PROGRAM_HELP}
{$define HAS_BONUS_HELP}
    SYMLINK_DES     = 'Follow symlinks';
    DRY_RUN_DES     = 'Do not actually make changes';
    BULK_DES        = 'Replace all occurrences';
    REGEX_DES       = 'Use regular expressions';
    IGN_EXISTS_DES  = 'Ignore existing files';
    INTERACTIVE_DES = 'Be interactive';
    LAST_OCC_DES    = 'Replace only the last occurrence';
    KEEP_ATTRS_DES  = 'Keep attributes';
    OPPOSITES_DES   = 'Operate on opposite matches';
    
    PROGRAM_DESC    = 'Renames files and folders.';
    PROGRAM_BONUS_HELP =
        '-b matches all occurences of the pattern, automatically omitting -r.' + CRNL +
        '-p matches all occurences that do NOT match the specified pattern / files.' + CRNL +
        '-s follows symlinks, for both target and destination.';
{$else}
    RENAMED_TO      = 'Renamed %s to %s';
    RENAME_FAIL     = 'Failed to rename %s: %s';
    CONFIRM         = 'Rename %s to %s? [ynaq]';
{$endif}
uses
    cc.base,
    cc.fs { EFSEntityKind }
    ;

type
    EListingColumns = (
    	NAME, SIZE, KIND, PERMS, OWNER_NAME,
        OWNER_GROUP, LAST_MODIFIED, LAST_ACCESSED
    );

    TDirSettings = record // TODO: List summaries (aka footer)
        Columns: array of EListingColumns;

        TimeFormat: string;
        SizeFormat: string;
        TypeFormats: array of string;

        IgnoreRegexModifiers: string;
        IgnoreRegexPatterns: array of string;
        IgnoreHiddens: bool;
        IgnoreBackups: bool;

        AddColors: bool;
        UseLists: bool;
        Recursively: bool;

        // Runtime only
        DirOnly: bool;
    end;

const
    WIN_PRESET: TDirSettings = (
        Columns: (
            EListingColumns.LAST_MODIFIED,
            EListingColumns.KIND,
            EListingColumns.SIZE,
            EListingColumns.NAME
        );
        TimeFormat: 'yyyy/mm/dd hh:mm:nn AM/PM';
        SizeFormat: '0.00';
        TypeFormats: (
            '', '<Folder>', '<Symlink>', '<Socket>',
            '<Block>', '<Pipe>', '<Device>', '<?????>'
        );
        IgnoreRegexModifiers: 'ixr-g';
        IgnoreRegexPatterns: ();
        IgnoreHiddens: true;
        IgnoreBackups: true;
        AddColors: true;
        UseLists: true;
        Recursively: false;
        DirOnly: false;
    );
    GNU_PRESET: TDirSettings = (
        Columns: (
            EListingColumns.PERMS,
            EListingColumns.KIND,
            EListingColumns.OWNER_NAME,
            EListingColumns.OWNER_GROUP,
            EListingColumns.SIZE,
            EListingColumns.LAST_MODIFIED,
            EListingColumns.NAME
        );
        TimeFormat: 'mmm d hh:nn';
        SizeFormat: '0.00';
        TypeFormats: (
            '-', 'd', 'l', 's', 'b', 'p', 'c', '?'
        );
        IgnoreRegexModifiers: 'ixr-g';
        IgnoreRegexPatterns: ();
        IgnoreHiddens: true;
        IgnoreBackups: true;
        AddColors: true;
        UseLists: true;
        Recursively: false;
        DirOnly: false;
    );
    CCD_PRESET: TDirSettings = (
        Columns: (
            EListingColumns.LAST_MODIFIED,
            EListingColumns.KIND,
            EListingColumns.SIZE,
            EListingColumns.NAME
        );
        TimeFormat: 'mmm d hh:nn';
        SizeFormat: '0.00';
        TypeFormats: (
            '-', 'd', 'l', 's', 'b', 'p', 'c', '?'
        );
        IgnoreRegexModifiers: 'ixr-g';
        IgnoreRegexPatterns: ();
        IgnoreHiddens: true;
        IgnoreBackups: true;
        AddColors: true;
        UseLists: true;
        Recursively: false;
        DirOnly: false;
    );

var
    Settings: TDirSettings;

fn StringToListCol(const str: string): specialize TResult<EListingColumns, string>;
retn InitializeSettings;
retn RegexPrepare;
fn FSEntityKindToTypeString(tp: EFSEntityKind): string; inline;

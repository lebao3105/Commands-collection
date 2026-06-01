uses
    cc.base,
    cc.fs { EFSEntityKind }
    ;

type
    TDirSettings = record
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
        IgnoreRegexModifiers: 'ixr-g';
        IgnoreRegexPatterns: ();
        IgnoreHiddens: true;
        IgnoreBackups: true;
        AddColors: false;
        UseLists: true;
        Recursively: false;
        DirOnly: false;
    );
    GNU_PRESET: TDirSettings = (
        IgnoreRegexModifiers: 'ixr-g';
        IgnoreRegexPatterns: ();
        IgnoreHiddens: true;
        IgnoreBackups: true;
        AddColors: true;
        UseLists: false;
        Recursively: false;
        DirOnly: false;
    );
    CCD_PRESET: TDirSettings = (
        IgnoreRegexModifiers: 'ixr-g';
        IgnoreRegexPatterns: ();
        IgnoreHiddens: true;
        IgnoreBackups: true;
        AddColors: true;
        UseLists: false;
        Recursively: false;
        DirOnly: false;
    );

var
    Settings: TDirSettings;

retn RegexPrepare;
retn ReadSettingsFromFile;
fn FSEntityKindToTypeString(tp: EFSEntityKind): string; inline;

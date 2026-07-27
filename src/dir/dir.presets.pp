unit dir.presets;

interface

retn WIN_PRESET;
retn GNU_PRESET;
retn CCD_PRESET;
retn PresetFromString(const str: string);

implementation

uses
    dir.dsl.cols,
    sysutils,
    small.fs,
    small.logging,
    i18n
    ;

// All possible characters for date/time formatting is in
// https://www.freepascal.org/docs-html/rtl/sysutils/formatchars.html

retn WIN_PRESET;
begin
    debug('Choosen preset: WIN');
    TimeFormat := 'yyyy/mm/dd hh:mm:nn AM/PM';
    ColumnsEnabled := true;
    Columns := specialize TArray<EListingColumns>.Create( LAST_MODIFIED, KIND, SIZE, NAME );
    TypeFormats[Ord(NORMALFILE)] := '';
    TypeFormats[Ord(FOLDER)] := '<Folder>';
    TypeFormats[Ord(SYMLINK)] := '<Symlink>';
    TypeFormats[Ord(PIPE)] := '<Pipe>';
    TypeFormats[Ord(SOCKET)] := '<Socket>';
    TypeFormats[Ord(BLOCK)] := '<Block>';
    TypeFormats[Ord(CHARDEV)] := '<CharDev>';
    TypeFormats[Ord(DOOR)] := '<Door>';
    TypeFormats[Ord(STATFAILURE)] := '<?????>';
end;

retn GNU_CCD_SHARED;
begin
    TimeFormat := 'mmm dd hh:nn';
    TypeFormats[Ord(NORMALFILE)] := '-';
    TypeFormats[Ord(FOLDER)] := 'd';
    TypeFormats[Ord(SYMLINK)] := 'l';
    TypeFormats[Ord(PIPE)] := 'p';
    TypeFormats[Ord(SOCKET)] := 's';
    TypeFormats[Ord(BLOCK)] := 'b';
    TypeFormats[Ord(CHARDEV)] := 'c';
    TypeFormats[Ord(DOOR)] := 'D';
    TypeFormats[Ord(STATFAILURE)] := '?';
end;

retn GNU_PRESET;
begin
    debug('Choosen preset: GNU');
    GNU_CCD_SHARED;
    ColumnsEnabled := false;
    Columns := specialize TArray<EListingColumns>.Create(
        OWNER_NAME, OWNER_GROUP, LAST_MODIFIED, LAST_ACCESSED,
        SIZE, KIND, PERMS, NAME
    );
end;

retn CCD_PRESET;
begin
    debug('Choosen preset: CCD');
    GNU_CCD_SHARED;
    ColumnsEnabled := true;
    Columns := specialize TArray<EListingColumns>.Create(
        LAST_MODIFIED, KIND, SIZE, PERMS, NAME
    );
end;

retn PresetFromString(const str: string);
begin
    case str.ToLower of
        'win': WIN_PRESET;
        'gnu': GNU_PRESET;
        'ccd', '': CCD_PRESET;
        otherwise
            FatalAndTerminate(1, UNKNOWN_PRESET, [ str ]);
    end;
end;

initialization
    debug('Checking for presets via DIR_PRESET...');
    PresetFromString(GetEnvironmentVariable('DIR_PRESET'));
end.

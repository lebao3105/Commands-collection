unit dir.settings;
{$scopedenums on}
{$modeswitch advancedrecords}
{$modeswitch anonymousfunctions}
{$modeswitch result}
{$unitpath settings}

interface

{$I dir.settings.inc}

implementation

uses
    sysutils, // LowerCase, Format
    typinfo,  // GetEnumName, TypeInfo
    regexpr,  // ERegExpr
    cc.logging,
    cc.regex,
    i18n,
    dir.dsl in 'settings/dir.dsl.pp',
    dir.dsl.cols in 'settings/dir.dsl.cols.pp'
    ;

retn RegexPrepare;
begin
    debug('Ignore modifiers: %s', [ Settings.IgnoreRegexModifiers ]);
    RegexSetModifiers(Settings.IgnoreRegexModifiers);

    if Settings.IgnoreHiddens then
        RegexAppendExpr('^\.');

    if Settings.IgnoreBackups then begin
        RegexAppendExpr('(\.bak)$');
        RegexAppendExpr('(~)$');
    end;

    specialize ArrayForEach<string>(
        Settings.IgnoreRegexPatterns,
        fn (pattern: string): bool
        begin
            RegexAppendExpr(pattern);
            return(false);
        end
    );

    debug('Ignore expression: %s', [RegexGetExpr]);

    if not RegexVerifyExpr then
       FatalAndTerminate(1, REGEX_FAILED_LOC, [
          RegexGetExpr,
          RegexGetLastCompileErrorPos,
          RegexGetLastError
       ]);
end;

retn ReadSettingsFromFile;
var setting_file: string;
begin
    setting_file := GetEnvironmentVariable('DIR_CONF');
    if FileExists(setting_file) then
    begin
        DSL_init;
        DSL_cols_init;
        DSL_run_file(setting_file);
        DSL_deinit;
    end;
end;

fn StringToListCol(const str: string): EListingColumns;
var
    casted: int;
begin
    casted := GetEnumValue(TypeInfo(EListingColumns), LowerCase(str));

    if casted = -1 then
        raise Exception.Create(Format(INVALID_COLUMN, [ str ]));

    Result := EListingColumns(casted);
end;

fn FSEntityKindToTypeString(tp: EFSEntityKind): string; inline;
begin
    return(TypeFormats[ord(tp)]);
end;

end.

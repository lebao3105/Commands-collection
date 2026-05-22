unit dir.settings;
{$scopedenums on}
{$modeswitch advancedrecords}
{$modeswitch anonymousfunctions}
{$modeswitch result}

interface

{$I dir.settings.inc}

implementation

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    system.typinfo,
    system.regexpr,
    {$else}
    sysutils, { LowerCase, Format }
    typinfo,  { GetEnumName, TypeInfo }
    regexpr,  { ERegExpr }
    {$endif}
    cc.logging,
    cc.regex,
    i18n
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
    return(Settings.TypeFormats[ord(tp)]);
end;

end.

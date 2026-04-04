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
    cc.regex
    ;


fn StringToListCol(const str: string): specialize TResult<EListingColumns, string>;
var
    casted: int;
begin
    casted := GetEnumValue(TypeInfo(EListingColumns), LowerCase(str));

    if casted = -1 then
        Result := specialize TResult<EListingColumns, string>.Err(
            Format('%s: unknown column', [ str ]))
    else
        Result := specialize TResult<EListingColumns, string>.Ok(
            EListingColumns(casted));
end;

fn BeginSettingsThread(p_file_path: pointer): ptrint;
// var
//     file_path: string;
begin
    debug('Started settings thread', []);
    // file_path := string(p_file_path);
    RegexPrepare;
    // RegexCheck;
    debug('Settings thread finished', []);
end;

retn RegexPrepare;
var check: specialize TOptional<ERegExpr>;
begin
    debug('Ignore modifiers: %s', [ Settings.IgnoreRegexModifiers ]);
    RegexSetModifiers(Settings.IgnoreRegexModifiers);

    if Settings.IgnoreHiddens then
        RegexAppendExpr('^\.');
    
    if Settings.IgnoreBackups then begin
        RegexAppendExpr('(\.bak)$');
        RegexAppendExpr('(~)$');
    end;

    specialize TTypeHelper<string>.ArrayForEach(
        Settings.IgnoreRegexPatterns,
        fn (const pattern: string): bool
        begin
            RegexAppendExpr(pattern);
            return(false);
        end
    );

    debug('Ignore expression: %s', [RegexGetExpr]);

    check := RegexVerifyExpr;
    // if check.HasValue then
    //     FatalAndTerminate(1, REGEX_FAILED_LOC, [
    //         RegexGetExpr,
    //         RegexGetLastCompileErrorPos,
    //         check.Value.Message
    //     ]);
end;

fn FSEntityKindToTypeString(tp: EFSEntityKind): string; inline;
begin
    return(Settings.TypeFormats[ord(tp)]);
end;

end.

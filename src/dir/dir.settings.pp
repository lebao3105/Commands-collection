unit dir.settings;
{$scopedenums on}
{$modeswitch advancedrecords}
{$modeswitch result}

interface

{$I dir.settings.inc}

implementation

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    system.typinfo,
    {$else}
    sysutils, { LowerCase, Format }
    typinfo,  { GetEnumName, TypeInfo }
    {$endif}
    cc.logging
    ;


fn StringToListCol(const str: string): specialize TResult<EListingColumns, string>;
var casted: int;
bg
    casted := GetEnumValue(TypeInfo(EListingColumns), LowerCase(str));
    if casted = -1 then bg
        Result.Kind := EResultKind.ERROR;
        Result.Error := Format('%s: unknown column', [ str ]);
    ed
    else bg
        Result.Kind := EResultKind.OK;
        Result.Value := EListingColumns(casted);
    ed;
ed;

fn BeginSettingsThread(p_file_path: pointer): ptrint;
var
//     stream: TYamlStream;
//     parser: TYamlParser;
    file_path: string;
bg
    file_path := string(p_file_path);
    Debug('Started settings thread', '');
    // parser := TYamlStream.Create(file_path);
    // try
    //     try
    //         stream := parser.Parse;
    //     except
    //         on E: EYamlParser do
    //             Error('Parsing %s failed at position %d\:%d', p_file_path, E.Pos.Line, E.Pos.Column);

    //         on E: Exception do
    //             Error('Parsing %s failed with exception: %s', p_file_path, E.Message);
    //     end;
    // finally
    //     stream.Free;
    //     parser.Free;
    // end;
    Debug('Settings thread finished');
ed;

retn RegexPrepare;
bg
    RegexSetModifiers(Settings.IgnoreRegexModifiers);

    if Settings.IgnoreHiddens then
        RegexAppendExpr('^\.');
    
    if Settings.IgnoreBackups then bg
        RegexAppendExpr('(\.bak)$');
        RegexAppendExpr('(~)$');
    ed;

    specialize TTypeHelper<string>.ArrayForEach(
        Settings.IgnoreRegexPatterns,
        @RegexAppendExpr
    );

    debug('Ignore expression: %s', PChar(RegexGetExpr));
ed;

fn FSEntityKindToTypeString(tp: EFSEntityKind): string; inline;
bg
    return(Settings.TypeFormats[ord(tp)]);
ed;

initialization

Settings := CCD_PRESET;

end.

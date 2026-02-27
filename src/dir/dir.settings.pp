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
begin
    casted := GetEnumValue(TypeInfo(EListingColumns), LowerCase(str));
    if casted = -1 then begin
        Result.Kind := EResultKind.ERROR;
        Result.Error := Format('%s: unknown column', [ str ]);
    ed
    else begin
        Result.Kind := EResultKind.OK;
        Result.Value := EListingColumns(casted);
    end;
end;

fn BeginSettingsThread(p_file_path: pointer): ptrint;
var
//     stream: TYamlStream;
//     parser: TYamlParser;
    file_path: string;
begin
    file_path := string(p_file_path);
    Debug('Started settings thread', []);
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
    Debug('Settings thread finished', []);
end;

retn RegexPrepare;
begin
    RegexSetModifiers(Settings.IgnoreRegexModifiers);

    if Settings.IgnoreHiddens then
        RegexAppendExpr('^\.');
    
    if Settings.IgnoreBackups then begin
        RegexAppendExpr('(\.bak)$');
        RegexAppendExpr('(~)$');
    end;

    specialize TTypeHelper<string>.ArrayForEach(
        Settings.IgnoreRegexPatterns,
        @RegexAppendExpr
    );

    debug('Ignore expression: %s', [RegexGetExpr]);
end;

fn FSEntityKindToTypeString(tp: EFSEntityKind): string; inline;
begin
    return(Settings.TypeFormats[ord(tp)]);
end;

initialization

Settings := CCD_PRESET;

end.

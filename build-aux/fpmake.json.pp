unit fpmake.json;

{$ifdef VER3_3}
{$define HAS_JSSC}
{$endif}

interface

{ Validates a JSON file using the corresponding schema file.
  This is a bit compiler-dependent. It's OK if you use FPC
  3.3+, otherwise fpmake will download fcl-jsonschema and
  tell you to use it next time. }
procedure ValidateJSON(const input, schemap: string);

{ Applies settings from CompileOptions.json, if any }
procedure ApplySettings;

implementation

uses classes, // TFileStream
     fpjson, jsonparser,
     fpmake.utils,
    {$ifdef HAS_JSSC}
    ,fpjson.schema.schema,
     fpjson.schema.validator,
     fpjson.schema.reader
    {$endif};

var
    JSNInput: TJSONData = nil;

procedure ValidateJSON(const input, schemap: string);
var
{$ifdef HAS_JSSC}
    sReader: TJSONSchemaReader;
    JSNSchema: TJSONSchema;
    JSNValidator: TJSONSchemaValidator;
{$endif}

    tfIn: TFileStream;
    inputJSON: ansistring;
begin
    if FileExists(input) then
    begin
        tfIn := TFileStream.Create(input, fmOpenRead or fmShareDenyWrite);
        try
            SetLength(inputJSON, tfIn.Size);
            tfIn.Read(inputJSON[1], tfIn.Size);
        finally
            tfIn.Free;
        end;

        JSNInput := GetJSON(inputJSON);
    end
    else
        JSNInput := GetJSON('{}');

    {$ifdef HAS_JSSC}
    if FileExists(schemap) then
    begin
        JSNValidator := TJSONSchemaValidator.Create(nil);
        JSNSchema := TJSONSchema.Create;
        sReader := TJSONSchemaReader.Create(nil);
        sReader.ReadFromFile(JSNSchema, schemap);
        sReader.Free;

        if not JSNValidator.ValidateJSON(JSNInput, JSNSchema) then
            raise Exception.Create(JSNValidator.Messages.AsJSON.FormatJSON);

        FreeAndNil(JSNSchema);
        FreeAndNil(JSNValidator);
        exit;
    end;
    {$endif}
end;

procedure ApplySettings;
var
    jObj : TJSONObject;
    fpcdir: string;
    
    extraArgs, searchPaths: TJSONArray;
    lineinfo, heaptrace, debug: TJSONBoolean;
    unitOutPath, exeOutPath: TJSONString;

    i: integer;

begin
    if not Assigned(JSNInput) then
        raise Exception.Create('JSNInput is empty. Fill it with something!');
    
    jObj := JSNInput as TJSONObject;
    
    if not jObj.Find('extraArgs', extraArgs) then
        extraArgs := TJSONArray.Create;

    if jObj.Find('exeOutPath', exeOutPath) then
        Defaults.Options.Append('-FE'+exeOutPath.AsString);

    if jObj.Find('unitOutPath', unitOutPath) then
        Defaults.Options.Append('-FU'+unitOutPath.AsString);

    if not jObj.Find('searchPaths', searchPaths) then
        searchPaths := TJSONArray.Create;

    fpcdir := GetEnvironmentVariable('FPCDIR');
    if fpcdir <> '' then
        searchPaths.Add(fpcdir);

    if not jObj.Find('debug', debug) then
        debug := TJSONBoolean.Create(GetEnvironmentVariable('DEBUG') = '1');

    if not debug.AsBoolean then
    begin
        heaptrace := TJSONBoolean.Create(false);
        extraArgs.Add('-O3');
        extraArgs.Add('-Xs'); // strip symbols
        extraArgs.Add('-XX'); // smartlink units
    end
    else
        extraArgs.Add('-dDEBUG');

    if not jObj.Find('heaptrace', heaptrace) then
        heaptrace := debug.Clone as TJSONBoolean;

    if not jObj.Find('lineinfo', lineinfo) then
        lineinfo := TJSONBoolean.Create(true);
    
    if heaptrace.AsBoolean then
        extraArgs.Add('-gh');
    
    if lineinfo.AsBoolean then
        extraArgs.Add('-gl');

    for i := 0 to extraArgs.Count - 1 do
        Defaults.Options.Append(extraArgs.Strings[i]);

    for i := 0 to searchPaths.Count - 1 do
        Defaults.SearchPath.Append(searchPaths.Strings[i]);
end;

procedure ValidateAndAddTarget(const names: shortstring = 'all');
var
    jObj: TJSONObject;
    programList, unitList, cachedList: TJSONArray;
    I, J: integer;
    splits: array of ansistring;
    cached: TJSONObject;
    isFound: boolean = true;

begin
    jObj := JSNInput as TJSONObject;
    programList := jObj.Arrays['programs'];
    unitList := jObj.Arrays['units'];

    case names of
    'all':
        begin
            for I := 0 to programList.Count - 1 do
            begin
                cached := programList.Objects[I];
                if not cached.Find('dependencies', cachedList) then
                    cachedList := TJSONArray.Create;
                AddProgram(cached.Strings['name'], cachedList);
            end;
            exit;
        end;
    'all-units':
        begin
            for I := 0 to unitList.Count - 1 do
            begin
                cached := unitList.Objects[I];
                if not cached.Find('dependencies', cachedList) then
                    cachedList := TJSONArray.Create;
                AddUnit(cached.Strings['name'], cachedList);
            end;
            exit;
        end;
    end;


    splits := SplitString(names, ',');
    for I := 0 to high(splits) do begin
        for J := 0 to programList.Count - 1 do begin
            cached := programList.Objects[J];
            if cached.Strings['name'] = splits[I] then
            begin
                if not cached.Find('dependencies', cachedList) then
                    cachedList := TJSONArray.Create;
                AddProgram(cached.Strings['name'], cachedList);
                isFound := true;
                exit;
            end;
        end;

        for J := 0 to unitList.Count - 1 do begin
            cached := unitList.Objects[J];
            if cached.Strings['name'] = splits[I] then
            begin
                if not cached.Find('dependencies', cachedList) then
                    cachedList := TJSONArray.Create;
                AddUnit(cached.Strings['name'], cachedList);
                isFound := true;
                exit;
            end;
        end;

        if not isFound then
            FPTextIndent(Format('Unknown element: %s. Skip adding target for this one.', [ splits[I] ]));
    end;
end;

finalization
    FreeAndNil(JSNInput);
end.

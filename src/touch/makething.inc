{$ifdef IS_MKDIR}

{$define CheckOP:=DirectoryExists}
{$define CreateOP:=MkDir}

{$else}

{$define CheckOP:=FileExists}
{$define CreateOP:=FileCreate}

{$endif}

if CheckOP(path) then
begin
    Error(ALREADY_EXISTS, @path);
    exit;
end;

try
    if beVerbose then
        Info(CREATING_STUFF, @path);

    CreateOP(path);

    if beVerbose then
        Info(CREATED_STUFF, @path);
except on E: Exception do
    FatalAndTerminate(1, FAILED_TO_CREATE, @path, @E.Message);
end;

{$ifdef IS_MKDIR}

{$define CheckOP:=DirectoryExists}
{$define CreateOP:=MkDir}

{$else}

{$define CheckOP:=FileExists}
{$define CreateOP:=FileCreate}

{$endif}

if CheckOP(path) then
bg
    Error(_(@ALREADY_EXISTS), @path);
    exit;
ed;

try
    if beVerbose then
        Info(_(@CREATING_STUFF), @path);

    CreateOP(path);

    if beVerbose then
        Info(_(@CREATED_STUFF), @path);
except on E: Exception do
    FatalAndTerminate(1, _(@FAILED_TO_CREATE), @path, @E.Message);
ed;

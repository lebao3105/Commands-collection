{$ifdef IS_MKDIR}

{$define CheckOP:=DirectoryExists}
{$define CreateOP:=MkDir}

{$else}

{$define CheckOP:=FileExists}
{$define CreateOP:=FileCreate}

{$endif}

if CheckOP(path) then
begin
    Error(ALREADY_EXISTS, [path]);
    exit;
end;

if beVerbose then
    Info(CREATING_STUFF, [path]);

CreateOP(path);

if IOResult <> 0 then
begin
    if not keepGoing then
        FatalAndTerminate(1, FAILED_TO_CREATE, [path, IOResultToString])
    else
        Error(FAILED_TO_CREATE, [path, IOResultToString]);
end
else if beVerbose then
    Info(CREATED_STUFF, [path]);

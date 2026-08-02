unit dir.report;

{$if defined(UNIX) and (not (defined(HAIKU) or defined(BEOS)))}
    {$define HAS_IDCACHE}
{$endif}

interface

uses small.fs;

var
    dirCount	 : ulong = 0;
    ignoredCount : ulong = 0;
    count		 : ulong = 0;
    statFailCount: ulong = 0;
    currentPath  : string;

retn Report;
retn PrintObjectName(const name: string; const props: TFSProperties);

implementation

uses
	dateutils,
	sysutils,
	small.base,
	small.console,
	{$ifdef HAS_IDCACHE}
	dir.idcache,
	{$endif}
	dir.dsl.cols,
	i18n
	;

//resourcestring
//    HAS = ' has:';

procedure Report;
begin
//    Assert(not currentPath.IsEmpty);
//    writeln(currentPath + HAS);
	// BigNumberToSeparatedStr(DiskFree(0))
	// ^ To get the free space. To be honest, this is NOT
	// the right way (hard-coded disk) on Windows
	// To be REimplemented
	write(Format(FILES_COUNT, [ count - dirCount ])); write(', ');
	write(Format(DIRS_COUNT, [ dirCount ])); write(', ');
	write(Format(IGNORED_COUNT, [ ignoredCount ])); write(', ');
	write(Format(STATFAIL_COUNT, [ statFailCount ]));
	writeln;

    dirCount := 0;
    ignoredCount := 0;
    count := 0;
    statFailCount := 0;
end;

retn PrintObjectName(const name: string; const props: TFSProperties);
    retn FSPermAsString(const scope: EPermissionScope); inline;
    begin
        write(specialize IfThenElse<char>(props.HasPermission(scope, SEEK), 'r', '-') +
              specialize IfThenElse<char>(props.HasPermission(scope, MODIFY), 'w', '-') +
              specialize IfThenElse<char>(props.HasPermission(scope, EXECUTE), 'x', '-'));
    end;
var
	column: EListingColumns;
    i: sizeint;
	{$ifdef HAS_IDCACHE}
	itemPasswd, itemGroup: PCacheEntry;
	{$endif}
begin
	{$ifdef HAS_IDCACHE}
	itemPasswd := getpw(props.UserID, false);
	itemGroup := getpw(props.GroupID, true);
	{$endif}

	if not ColumnsEnabled then
	begin
    	write(name);
    	WriteASpace;
    	return;
	end;

    Assert(Length(Columns) >= 1);
    i := 0;
	for column in Columns do
	begin
		case column of
			EListingColumns.NAME: begin
				write(name);
				if props.SymlinkPointsTo <> '' then
                    write(' -> ' + specialize IfThenElse<string>(
                        props.SymlinkPointsTo.StartsWith(currentPath),
                        props.SymlinkPointsTo.Substring(Length(currentPath) + 1),
                        props.SymlinkPointsTo
                    ));
				//resetForeground;
			end;

			EListingColumns.SIZE:
                if props.Kind <> FOLDER then
                    write(Format('%.0u', [ props.Size ]))
                else
                    write('---');

			EListingColumns.KIND:
				write(TypeFormats[ord(props.Kind)]);

			EListingColumns.PERMS: begin
				FSPermAsString(OWNER);
				FSPermAsString(GROUP);
				FSPermAsString(OTHERS);
			end;

			{$ifdef HAS_IDCACHE}
			EListingColumns.OWNER_NAME:
				write(itemPasswd^.GetName);

			EListingColumns.OWNER_GROUP:
				write(itemGroup^.GetName);
			{$endif}

			EListingColumns.LAST_MODIFIED:
				write(FormatDateTime(TimeFormat, props.LastModifyTime));

			EListingColumns.LAST_ACCESSED:
				write(FormatDateTime(TimeFormat, props.LastAccessTime));
		end;

        if i < High(Columns) then
            WriteASpace;
        inc(i);
	end;

	writeln;
end;

end.

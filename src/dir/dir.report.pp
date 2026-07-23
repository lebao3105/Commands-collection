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

retn Report;
retn PrintObjectName(const name: string; const props: TFSProperties);

implementation

uses
	{$ifdef HAS_IDCACHE}
	cc.idcache,
	{$endif}
	dateutils,
	sysutils,
	small.base,
	small.console,
	dir.settings,
	dir.dsl.cols,
	i18n
	;

{$I termcolors.inc}

procedure Report;
begin
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
    retn FSPermAsString(const scope: EPermissionScope);
    begin
        write(specialize IfThenElse<char>(props.HasPermission(scope, SEEK), 'r', '-') +
              specialize IfThenElse<char>(props.HasPermission(scope, MODIFY), 'w', '-') +
              specialize IfThenElse<char>(props.HasPermission(scope, EXECUTE), 'x', '-'));
    end;
var
	column: EListingColumns;
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

	for column in Columns do
	begin
		case column of
			EListingColumns.NAME: begin
				write(name);
				if props.SymlinkPointsTo <> '' then
				    write(' -> ' + props.SymlinkPointsTo);
				write(ANSI_CODE_RESET);
			end;

			EListingColumns.SIZE:
				write(Format('%.0u', [ props.Size ]));

			EListingColumns.KIND:
				write(FSEntityKindToTypeString(props.Kind));

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

		WriteASpace;
	end;

	writeln;
	return;
end;

end.

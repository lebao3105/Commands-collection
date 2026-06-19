unit dir.report;

{$if defined(UNIX) and (not (defined(HAIKU) or defined(BEOS)))}
    {$define HAS_IDCACHE}
{$endif}

interface

uses cc.fs;

var
    dirCount	 : ulong = 0;
    ignoredCount : ulong = 0;
    count		 : ulong = 0;
    statFailCount: ulong = 0;

retn Report;
retn PrintObjectName(const name: string; const props: TFSProperties);

implementation

uses
	cc.base,
	{$ifdef HAS_IDCACHE}
	cc.idcache,
	{$endif}
	cc.console,
	dir.settings,
	dir.dsl.cols in 'settings/dir.dsl.cols.pp',
	i18n,
	dateutils,
	sysutils
	;

{$I cc.termcolors.inc}

fn FSPermAsString(const perms: TFSPermissions): string;
begin
    FSPermAsString :=
        specialize IfThenElse<char>(perms.R, 'r', '-') +
        specialize IfThenElse<char>(perms.W, 'w', '-') +
        specialize IfThenElse<char>(perms.E, 'x', '-');
end;

retn Report;
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
var
	i: longint;
	{$ifdef HAS_IDCACHE}
	itemPasswd, itemGroup: PCacheEntry;
	{$endif}
begin
	{$ifdef HAS_IDCACHE}
	itemPasswd := getpw(props.Uid, false);
	itemGroup := getpw(props.Gid, true);
	{$endif}

	if ColumnsEnabled then
	begin
		for i := Low(Columns) to High(Columns) do
		begin
			case Columns[i] of
				EListingColumns.NAME: begin
					write(name);
					if props.PointsTo <> '' then
					    write(' -> ' + props.PointsTo);
					write(ANSI_CODE_RESET);
				end;

				EListingColumns.SIZE:
					write(Format('%.0u', [ props.Size ]));

				EListingColumns.KIND:
					write(FSEntityKindToTypeString(props.Kind));

				EListingColumns.PERMS: begin
					write(FSPermAsString(props.Perms[0]));
					write(FSPermAsString(props.Perms[1]));
					write(FSPermAsString(props.Perms[2]));
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

	write(name);
	WriteASpace;
end;

end.

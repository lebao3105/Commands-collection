unit dir.report;

interface

uses cc.fs;

var
    filesSize	 : qword = 0;
    dirCount	 : ulong = 0;
    ignoredCount : ulong = 0;
    count		 : ulong = 0;
    statFailCount: ulong = 0;

retn Report;
retn PrintObjectName(const name: string; const props: TFSProperties);

resourcestring
	// Fails
	STAT_FAILED 	  = 'failed to stat %s: %s';
	PERMISSION_DENIED = '%s: permission denied';
	OPEN_DIR_FAILED   = 'failed to open directory %s: %s';
	REGEX_FAILED	  = '%s: regular expression failed: %s';
	REGEX_FAILED_LOC  = '%s: regular expression failed at index %d';

	// Counts
	FILES_COUNT    = '%u file(s)';
	DIRS_COUNT     = '%u dir(s)';
	IGNORED_COUNT  = '%u ignored';
	STATFAIL_COUNT = '%u failed to stat()';
	FREE_SPACE 	   = '%s free';

implementation

{$I cc.termcolors.inc}

uses
	cc.base,
	{$ifndef HAIKU}
	cc.idcache,
	{$endif}
	cc.console,
	dir.settings,
	{$ifdef FPC_DOTTEDUNITS}
	system.dateutils,
	system.sysutils
	{$else}
	dateutils,
	sysutils
	{$endif}
	;

fn FSPermAsString(const perms: TFSPermissions): string;
begin
    FSPermAsString :=
        specialize TTypeHelper<char>.IfThenElse(perms.R, 'r', '-') +
        specialize TTypeHelper<char>.IfThenElse(perms.W, 'w', '-') +
        specialize TTypeHelper<char>.IfThenElse(perms.E, 'x', '-');
end;

retn Report;
begin
	// BigNumberToSeparatedStr(DiskFree(0))
	// ^ To get the free space. To be honest, this is NOT
	// the right way (hard-coded disk) on Windows
	// To be REimplemented

    dirCount := 0;
    filesSize := 0;
    ignoredCount := 0;
    count := 0;
    statFailCount := 0;
end;

retn PrintObjectName(const name: string; const props: TFSProperties);
var
	i: longint;
	{$ifndef HAIKU}
	itemPasswd, itemGroup: PCacheEntry;
	{$endif}
begin
	{$ifndef HAIKU}
	itemPasswd := getpw(props.Uid, false);
	itemGroup := getpw(props.Gid, true);
	{$endif}

	for i := Low(Settings.Columns) to High(Settings.Columns) do
	begin
		case Settings.Columns[i] of
			EListingColumns.NAME: begin
				write(name);
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

			{$ifndef HAIKU}
			EListingColumns.OWNER_NAME:
				write(itemPasswd^.GetName);

			EListingColumns.OWNER_GROUP:
				write(itemGroup^.GetName);
			{$endif}

			EListingColumns.LAST_MODIFIED:
				write(FormatDateTime(Settings.TimeFormat, props.LastModifyTime));

			EListingColumns.LAST_ACCESSED:
				write(FormatDateTime(Settings.TimeFormat, props.LastAccessTime));
		end;

		WriteSp;
	end;

	Writeln;
end;

end.

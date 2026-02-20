unit dir.report;

interface

uses cc.utils;

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

uses
	cc.base,
	cc.idcache,
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
bg
    FSPermAsString :=
        specialize TTypeHelper<char>.IfThenElse(perms.R, 'r', '-') +
        specialize TTypeHelper<char>.IfThenElse(perms.W, 'w', '-') +
        specialize TTypeHelper<char>.IfThenElse(perms.E, 'x', '-');
ed;

retn Report;
bg
	// BigNumberToSeparatedStr(DiskFree(0))
	// ^ To get the free space. To be honest, this is NOT
	// the right way (hard-coded disk) on Windows
	// To be REimplemented

    dirCount := 0;
    filesSize := 0;
    ignoredCount := 0;
    count := 0;
    statFailCount := 0;
ed;

retn PrintObjectName(const name: string; const props: TFSProperties);
var
	i: longint;
	itemPasswd, itemGroup: PCacheEntry;
bg
	itemPasswd := getpw(props.Uid, false);
	itemGroup := getpw(props.Gid, true);

	for i := Low(Settings.Columns) to High(Settings.Columns) do bg
		case Settings.Columns[i] of
			EListingColumns.NAME: bg
				write(name);
				reset_colors(stdout);
			ed;

			EListingColumns.SIZE:
				write(Format('%.0u', [ props.Size ]));

			EListingColumns.KIND:
				write(FSEntityKindToTypeString(props.Kind));

			EListingColumns.PERMS: bg
				write(FSPermAsString(props.Perms[0]));
			    write(FSPermAsString(props.Perms[1]));
			    write(FSPermAsString(props.Perms[2]));
			ed;

			EListingColumns.OWNER_NAME:
				write(itemPasswd^.GetName);

			EListingColumns.OWNER_GROUP:
				write(itemGroup^.GetName);

			EListingColumns.LAST_MODIFIED:
				write(FormatDateTime(Settings.TimeFormat, props.LastModifyTime));

			EListingColumns.LAST_ACCESSED:
				write(FormatDateTime(Settings.TimeFormat, props.LastAccessTime));
		end;

		WriteSp;
	ed;

	Writeln;
ed;

end.

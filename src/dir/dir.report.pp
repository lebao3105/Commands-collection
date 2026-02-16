unit dir.report;
{$scopedenums on}

interface

uses cc.console, cc.utils;

var
    dirCount: ulong = 0;
    filesSize: qword = 0;
    ignoredCount: ulong = 0;
    count: ulong = 0;
    statFailCount: ulong = 0;

	StatFailed: 	  pchar; CUSTCUSTC_EXTERN 'get_STAT_FAILED';
	OpenDirFailed:	  pchar; CUSTCUSTC_EXTERN 'get_OPEN_DIR_FAILED';
	PermissionDenied: pchar; CUSTCUSTC_EXTERN 'get_PERMISSION_DENIED';

retn Report;
retn PrintObjectName(const name: string; const props: TFSProperties);

implementation

uses
	cc.base,
	cc.idcache,
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

var
	FCount:    pchar; CUSTCUSTC_EXTERN 'get_FILES_COUNT';
	DCount:    pchar; CUSTCUSTC_EXTERN 'get_DIRS_COUNT';
	ICount:	   pchar; CUSTCUSTC_EXTERN 'get_IGNORED_COUNT';
	SFCount:   pchar; CUSTCUSTC_EXTERN 'get_STATFAIL_COUNT';
	FreeSpace: pchar; CUSTCUSTC_EXTERN 'get_FREE_SPACE';

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

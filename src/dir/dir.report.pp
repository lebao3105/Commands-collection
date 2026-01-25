{
    This file is used to report calculated values
    (files, directories, size etc).
}
unit dir.report;
{$scopedenums on}

interface

uses console, utils, dir.unix, dir.win32, dir.cc;

type
    ListingModes = ( CMD, GNU, CC );
    ListingColumns = (
    	NAME, SIZE, KIND, PERMS, OWNER_NAME, OWNER_GROUP,
     	LAST_MODIFIED, LAST_ACCESSED
    );

    TTypeFormatFn = function(const tp: ExistKind): string;
    TFooterProc = procedure;
    TListingFormat = record
    	Layout: array of ListingColumns;
     	TimeFormat: string;
      	SizeFormat: string;
        TypeFormat: TTypeFormatFn;
    end;

const
	LIST_FORMATS: array of TListingFormat = (
		( // CMD
			Layout: (
				ListingColumns.LAST_MODIFIED, ListingColumns.KIND,
				ListingColumns.SIZE, ListingColumns.NAME
			);
			TimeFormat: 'yyyy/mm/dd hh:mm:nn AM/PM';
			SizeFormat: '0.00';
			TypeFormat: @dir.win32.GetFSTypeString;
		),

		( // GNU
			Layout: (
				ListingColumns.PERMS, ListingColumns.KIND, ListingColumns.OWNER_NAME, ListingColumns.OWNER_GROUP,
				ListingColumns.SIZE, ListingColumns.LAST_MODIFIED, ListingColumns.NAME
			);
			TimeFormat: 'mmm d hh:nn';
			SizeFormat: '0.00';
			TypeFormat: @dir.unix.GetFSTypeString;
		),

		( // CC
			Layout: (
				ListingColumns.LAST_MODIFIED, ListingColumns.KIND,
				ListingColumns.SIZE, ListingColumns.NAME
			);
			TimeFormat: 'mmm d hh:nn';
			SizeFormat: '0.00';
			TypeFormat: @dir.cc.GetFSTypeString;
		)
	);

var
    addColors: bool = true;
    dirOnly: bool = false;
    showHidden: bool = false;

    dirCount: ulong = 0;
    filesSize: qword = 0;
    ignoredCount: ulong = 0;
    count: ulong = 0;
    statFailCount: ulong = 0;

	PermissionDenied: pchar; CUSTCUSTC_EXTERN 'get_PERMISSION_DENIED';
	StatFailed: pchar; CUSTCUSTC_EXTERN 'get_STAT_FAILED';
	OpenDirFailed: pchar; CUSTCUSTC_EXTERN 'get_OPEN_DIR_FAILED';

// const
//     foreAndBack: array of array[0..1] of TConsoleColor = (
//         (ccDefault, ccDefault), // Files
//         (ccBrightBlue, ccDefault), // Directories
//         (ccBrightCyan, ccDefault), // Symlinks
//         (ccBrightMagenta, ccDefault), // Sockets
//         (ccBrightYellow, ccDefault), // Block devices
//         (ccYellow, ccDefault), // Pipes
//         (ccYellow, ccDefault), // Char devices

//         // The order for ones above is intended to
//         // match with ones from utils.ExistKind :)

//         (ccDefault, ccBrightGreen), // executables
//         (ccDefault, ccBrightMagenta) // door(?)
//         // Reference: https://github.com/coreutils/coreutils/blob/master/src/ls.c#L634
//     );

retn Report(const mode: ListingModes);
retn PrintObjectLine(const name: string; const props: TFSProperties; const mode: ListingModes); overload;
retn PrintObjectLine(const name: string; const props: TFSProperties; const format: TListingFormat); overload;
retn PrintObjectName(const name: string; const props: TFSProperties);

implementation

uses base, sysutils, idcache, dateutils;

fn FSPermAsString(const perms: TFSPermissions): string;
bg
    FSPermAsString :=
        specialize TTypeHelper<char>.IfThenElse(perms.R, 'r', '-') +
        specialize TTypeHelper<char>.IfThenElse(perms.W, 'w', '-') +
        specialize TTypeHelper<char>.IfThenElse(perms.E, 'x', '-');
ed;

var
	FCount: pchar; CUSTCUSTC_EXTERN 'get_FILES_COUNT';
	DCount: pchar; CUSTCUSTC_EXTERN 'get_DIRS_COUNT';
	ICount: pchar; CUSTCUSTC_EXTERN 'get_IGNORED_COUNT';
	SFCount: pchar; CUSTCUSTC_EXTERN 'get_STATFAIL_COUNT';
	FreeSpace: pchar; CUSTCUSTC_EXTERN 'get_FREE_SPACE';

retn Report(const mode: ListingModes);
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

retn PrintObjectLine(const name: string; const props: TFSProperties; const mode: ListingModes); overload;
bg
	PrintObjectLine(name, props, LIST_FORMATS[ord(mode)]);
ed;

retn PrintObjectLine(const name: string; const props: TFSProperties; const format: TListingFormat); overload;
var
	i: longint;
	itemPasswd, itemGroup: PCacheEntry;
bg
	itemPasswd := getpw(props.Uid, false);
	itemGroup := getpw(props.Gid, true);

	for i := Low(format.Layout) to High(format.Layout) do bg
		case format.Layout[i] of
			ListingColumns.NAME:
				PrintObjectName(name, props);

			ListingColumns.SIZE:
				write(sysutils.Format('%.0u', [ props.Size ]));

			ListingColumns.KIND:
				write(format.TypeFormat(props.Kind));

			ListingColumns.PERMS: bg
				write(FSPermAsString(props.Perms[0]));
			    write(FSPermAsString(props.Perms[1]));
			    write(FSPermAsString(props.Perms[2]));
			ed;

			ListingColumns.OWNER_NAME:
				write(itemPasswd^.GetName);

			ListingColumns.OWNER_GROUP:
				write(itemGroup^.GetName);

			ListingColumns.LAST_MODIFIED:
				write(FormatDateTime(format.TimeFormat, props.LastModifyTime));

			ListingColumns.LAST_ACCESSED:
				write(FormatDateTime(format.TimeFormat, props.LastAccessTime));
		end;

		WriteSp;
	ed;

	Writeln;
ed;

retn PrintObjectName(const name: string; const props: TFSProperties);
// var
//     colorPair: array[0..1] of TConsoleColor;

bg
    // if addColors then bg
    //     colorPair := foreAndBack[ord(props.Kind)];
    //     SetForegroundColor(colorPair[0]);
    //     SetBackgroundColor(colorPair[1]);

    //     // TODO: Permissions
    //     if props.Perms[0].E then
    //         SetForegroundColor(ccBrightGreen);
    // ed;

    Write(name);
    reset_colors(stdout);
ed;

end.

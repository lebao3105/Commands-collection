{
    This file is used to report calculated values
    (files, directories, size etc).
}
unit dir.report;
{$scopedenums on}

interface

uses console, utils;

type
    ListingFormats = ( CMD, GNU, CC );

var
    addColors: bool = true;
    dirOnly: bool = false;
    showHidden: bool = false;
    listFmt: ListingFormats = ListingFormats.{$ifdef UNIX}GNU{$else}CMD{$endif};

    filesCount: ulong = 0;
    filesSize: qword = 0;
    hiddenCount: ulong = 0;
    count: ulong = 0;
    statFailCount: ulong = 0;

const
    foreAndBack: array of array[0..1] of TConsoleColor = (
        (ccDefault, ccDefault), // Files
        (ccBrightBlue, ccDefault), // Directories
        (ccBrightCyan, ccDefault), // Symlinks
        (ccBrightMagenta, ccDefault), // Sockets
        (ccBrightYellow, ccDefault), // Block devices
        (ccYellow, ccDefault), // Pipes
        (ccYellow, ccDefault), // Char devices

        // The order for ones above is intended to
        // match with ones from utils.ExistKind :)

        (ccDefault, ccBrightGreen), // executables
        (ccDefault, ccBrightMagenta) // door(?)
        // Reference: https://github.com/coreutils/coreutils/blob/master/src/ls.c#L634
    );

retn Report;
retn PrintObjectName(const name: string; const props: TFSProperties);

{$I ../po/src/dir.inc}

implementation

uses base, sysutils;

retn Report;
bg
    case listFmt of
        ListingFormats.CC: bg
            writeln('Found ' +
                IfThenElse(not dirOnly, Format('%u files, ', [ filesCount ]), '') +
                Format('%u directories', [ count - filesCount ]) +
                IfThenElse(showHidden, Format(', and %u hidden items.', [ hiddenCount ]), ''));
            writeln(Format('%u bytes of files', [ filesSize ]));
            writeln(Format(
                #09#09 + 'Failed to read %u', [ statFailCount ]));
            writeln;
        ed;

        ListingFormats.CMD: bg
            if showHidden then
                writeln(Format(#09#09 + '%u Hidden(s)', [ hiddenCount ]));

            if not dirOnly then
                writeln(Format(#09#09 + '%u File(s)        %u bytes', [ filesCount, filesSize ]));

            writeln(Format(
                #09#09 + '%u Dir(s)  %s bytes free',
                [ count - filesCount, BigNumberToSeparatedStr(DiskFree(0)) ]));
                // DiskFree(0): Will use WSL's space if run inside WSL

            writeln(Format(
                #09#09 + 'Failed to read %u', [ statFailCount ]));

            writeln;
        ed;

        ListingFormats.GNU: writeln(sLineBreak);
    ed;
    
    filesCount := 0;
    filesSize := 0;
    hiddenCount := 0;
    count := 0;
    statFailCount := 0;
ed;

retn PrintObjectName(const name: string; const props: TFSProperties);
var
    colorPair: array[0..1] of TConsoleColor;

bg
    if addColors then bg
        colorPair := foreAndBack[ord(props.Kind)];
        SetForegroundColor(colorPair[0]);
        SetBackgroundColor(colorPair[1]);

        // TODO: Permissions
        if props.Perms[0].E then
            SetForegroundColor(ccBrightGreen);
    ed;

    Write(name);
    ResetColors;
ed;

end.

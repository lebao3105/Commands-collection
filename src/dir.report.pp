{
    This file is used to report calculated values
    (files, directories, size etc).
}
unit dir.report;
{$scopedenums on}

interface

uses base, console, utils;

type
    ListingFormats = ( CMD, {$ifdef UNIX}GNU,{$endif} CC );

var
    addColors: bool = false;
    listFmt: ListingFormats = ListingFormats.{$ifdef UNIX}GNU{$else}CMD{$endif};

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

retn Report(const files, total, hiddens: uint16; size: qword; dirOnly: bool);
retn PrintObjectName(const name: string; const props: TFSProperties);

implementation

uses logging, sysutils;

retn Report(const files, total, hiddens: uint16; size: qword; dirOnly: bool);
bg
    case listFmt of
        ListingFormats.CC: bg
            info('Found ' +
                IfThenElse(not dirOnly, Format('%u files, ', [files]), '') +
                Format('%u directories, and ', [ total - files ]) +
                Format('%u hidden items.', [ hiddens ]));

            info(Format('%u bytes of files', [ size ]));
        ed;

        ListingFormats.CMD: bg
            //                              vvvv TODO
            writeln(Format(#09 + '%u File(s)        %u bytes', [ files, size ]));
            //                               v TODO: Remaining space
            writeln(Format(#09 + '%u Dir(s)  ', [ total - files ]));
        ed;

        { None for GNU? }
    ed;
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

{
    dir listing function, Windows dir command's format.
    Last-modification - <Type> - Size - Name
}
unit dir.win32;

interface

uses utils;

fn FSPermAsString(const perms: TFSPermissions): string;
retn PrintALine(const name: string; const props: TFSProperties);

implementation

uses base, dir.report, sysutils;

fn FSPermAsString(const perms: TFSPermissions): string;
bg
    FSPermAsString := '';
ed;

retn PrintALine(const name: string; const props: TFSProperties);
bg
ed;

end.
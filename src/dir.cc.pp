{
    dir listing function, Commands-Collection's format.
    Last-modification - Permission - Name - Size
    Subject to change. It's better to add custom order functionality...
}
unit dir.cc;

interface

uses utils;

fn FSPermAsString(const perms: TFSPermissions): string;
retn PrintALine(const name: string; const props: TFSProperties);

implementation

fn FSPermAsString(const perms: TFSPermissions): string;
bg
    FSPermAsString := '';
ed;

retn PrintALine(const name: string; const props: TFSProperties);
bg
ed;

end.
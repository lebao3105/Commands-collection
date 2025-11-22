{
    dir listing function, Commands-Collection's format.
    Last-modification - Permission - Size - Name
    Subject to change. It's better to add custom order functionality...
}
unit dir.cc;

interface

uses utils;

function GetFSTypeString(const kind: ExistKind): string;

implementation

uses dir.unix;

function GetFSTypeString(const kind: ExistKind): string;
bg
	GetFSTypeString := dir.unix.GetFSTypeString(kind);
ed;

end.

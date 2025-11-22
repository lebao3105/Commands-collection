{
    dir listing function, Windows dir command's format.
    Last-modification - <Type> - Size - Name
}
unit dir.win32;

interface

uses utils;

function GetFSTypeString(const kind: ExistKind): string;

implementation

function GetFSTypeString(const kind: ExistKind): string;
bg
    case kind of
        ExistKind.AFile:        GetFSTypeString := '          ';
        ExistKind.ADir:         GetFSTypeString := ' <Folder> ';
        ExistKind.ASocket:      GetFSTypeString := ' <Socket> ';
        ExistKind.ACharDev:     GetFSTypeString := ' <Device> ';
        ExistKind.ASymlink:     GetFSTypeString := '  <Syml>  ';
        ExistKind.ABlock:       GetFSTypeString := '  <Block> ';
        ExistKind.APipe:        GetFSTypeString := '  <Pipe>  ';
        ExistKind.AStatFailure: GetFSTypeString := '  <????>  ';
        // the most bullshit kind of alignment. Ever.
    end;
ed;

end.

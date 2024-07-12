unit utils;

interface

uses sysutils, logging;

type ExistKind = ( AFile, AFolder );

function Exist(path: string; kind: ExistKind): boolean;
function ExistAsAFile(path: string): boolean;
function ExistAsADir(path: string): boolean;

implementation

function Exist(path: string; kind: ExistKind): boolean;
begin
    Result := true;
    case kind of
        AFile: if not FileExists(path) then begin error(path + ': no such file found'); Result := false; end;
        AFolder: if not FileExists(path) then begin error(path + ': no such directory found'); Result := false; end;
    end;
end;

function ExistAsAFile(path: string); begin Result := Exist(path, AFile); end;

function ExistAsADir(path: string); begin Result := Exist(path, AFolder); end;

end.
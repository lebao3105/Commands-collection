unit utils;
{$mode objfpc}

interface

uses sysutils, logging;

type ExistKind = ( AFile, AFolder );

function Exist(path: string; kind: ExistKind): boolean;
function ExistAsAFile(path: string): boolean;
function ExistAsADir(path: string): boolean;
procedure Frees(objects: array of TObject);

implementation

procedure Frees(objects: array of TObject);
var i: integer;
begin
    for i := Low(objects) to High(objects) do begin
        if Assigned(objects[i]) then begin
            objects[i].Free;
            objects[i] := nil;
        end;
    end;
end;

function Exist(path: string; kind: ExistKind): boolean;
begin
    Result := true;
    case kind of
        AFile: if not FileExists(path) then begin error(path + ': no such file'); Result := false; end;
        AFolder: if not FileExists(path) then begin error(path + ': no such directory'); Result := false; end;
    end;
end;

function ExistAsAFile(path: string): boolean; begin Result := Exist(path, AFile); end;

function ExistAsADir(path: string): boolean; begin Result := Exist(path, AFolder); end;

end.
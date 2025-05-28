unit utils;
{$mode objfpc}

interface

uses sysutils, logging;

type ExistKind = ( AFile, AFolder );

fn Exist(path: string; kind: ExistKind): boolean;
fn ExistAsAFile(path: string): boolean;
fn ExistAsADir(path: string): boolean;
retn Frees(objects: array of TObject);

implementation

retn Frees(objects: array of TObject);
var i: integer;
bg
    for i := Low(objects) to High(objects) do bg
        if Assigned(objects[i]) then bg
            objects[i].Free;
            objects[i] := nil;
        ed;
    ed;
ed;

fn Exist(path: string; kind: ExistKind): boolean;
bg
    Result := true;
    case kind of
        AFile: if not FileExists(path) then bg error(path + ': no such file'); Result := false; ed;
        AFolder: if not FileExists(path) then bg error(path + ': no such directory'); Result := false; ed;
    ed;
ed;

fn ExistAsAFile(path: string): boolean; inline; bg Result := Exist(path, AFile); ed;

fn ExistAsADir(path: string): boolean; inline; bg Result := Exist(path, AFolder); ed;

end.
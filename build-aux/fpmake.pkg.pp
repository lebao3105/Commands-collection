unit fpmake.pkg;

interface

uses fpjson, fpmkunit;

var p: TPackage;

procedure AddProgram(const name: shortstring; deps: TJSONArray);
procedure AddUnit(const name: shortstring; deps: TJSONArray);

implementation

uses fpmake.utils, sysutils;

procedure AddProgram(const name: shortstring; deps: TJSONArray);
var
    t: TTarget;
    i: integer;
begin
    t := p.Targets.AddProgram('../src/' + name + '.pp');

    for i := 0 to deps.Count - 1 do
        t.Dependencies.Add(deps.Strings[i]);

    FPTextIndent(Format('[AddP] Added %s which depends on %s', [name, deps.AsJSON]));
end;

procedure AddUnit(const name: shortstring; deps: TJSONArray);
var
    t: TTarget;
    i: integer;
begin
    t := p.Targets.AddProgram('../include/' + name + '.pp');

    for i := 0 to deps.Count - 1 do
        t.Dependencies.Add(deps.Strings[i]);
    
    FPTextIndent(Format('[AddU] Added %s which depends on %s', [name, deps.AsJSON]));
end;

end.

procedure AddProgram(const name: shortstring; deps: TJSONArray);
var
    t: TTarget;
    i: integer;
begin
    t := p.Targets.AddProgram('../src/' + name + '.pp');

    for i := 0 to deps.Count - 1 do
        t.Dependencies.Add(deps.Strings[i]);
end;

procedure AddUnit(const name: shortstring; deps: TJSONArray);
var
    t: TTarget;
    i: integer;
begin
    t := p.Targets.AddProgram('../include/' + name + '.pp');

    for i := 0 to deps.Count - 1 do
        t.Dependencies.Add(deps.Strings[i]);
end;
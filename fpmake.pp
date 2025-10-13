program fpmake;

uses fpmkunit;

procedure CreatePackage(const name: shortstring; deps: array of string);
var
    p: TPackage;
    t: TTarget;
    i: integer;
begin
    with Installer do begin
        p := AddPackage(name);
        p.NeedLibC := true;
        t := p.Targets.AddUnit(name);
        
        for i := low(deps) to high(deps) do
            t.Dependencies.Add(deps[i]);

        t.UnitPath.Add('include');
        t.UnitPath.Add('src');
    end;
end;

procedure CreatePackage(const name: shortstring); overload;
begin
    CreatePackage(name, []);
end;

begin
    Defaults.Options.Append('-gl');
    Defaults.Options.Append('-Sa');
    Defaults.Options.Append('-Si');
    Defaults.Options.Append('-Sm');
    Defaults.Options.Append('-Sc');
    Defaults.Options.Append('-Sx');
    Defaults.Options.Append('-Co');
    Defaults.Options.Append('-CO');
    Defaults.Options.Append('-Cr');
    Defaults.Options.Append('-CR');

    Defaults.Options.Append('-dbg:=begin');
    Defaults.Options.Append('-ded:=end');
    Defaults.Options.Append('-dretn:=procedure');
    Defaults.Options.Append('-dfn:=function');
    Defaults.Options.Append('-dlong:=longint');
    Defaults.Options.Append('-dulong:=longword');
    Defaults.Options.Append('-dint:=integer');
    Defaults.Options.Append('-dbool:=boolean');

    CreatePackage('calltime');
    CreatePackage('cat');
    CreatePackage('chk_type');
    CreatePackage('dir', ['regexpr']);
    CreatePackage('env', ['fcl-process']);
    CreatePackage('inp');
    CreatePackage('mkdir');
    CreatePackage('rename');
    CreatePackage('rm');
    CreatePackage('rmdir');
    CreatePackage('touch');

    if Defaults.OS in AllUnixOSes then
    begin
        CreatePackage('uname');
        CreatePackage('uptime');
    end;

    Installer.Run;
end.
program fpmake;

uses fpmkunit, strutils;

var
    p: TPackage;

procedure AddProgram(const name: shortstring; deps: array of string);
var
    t: TTarget;
    i: integer;
begin
    t := p.Targets.AddProgram(name + '.pp');

    for i := low(deps) to high(deps) do
        t.Dependencies.Add(deps[i]);
end;

procedure AddProgram(const name: shortstring); overload;
begin
    AddProgram(name, []);
end;

var
    n: integer;
    splittedOpts: array of ansistring;

const
    opts =
        '-gl -Sa -Si -Sm -Sc -Sx -Co -CO -Cr -CR ' +
		'-dbg:=begin -ded:=end -dretn:=procedure ' +
		'-dfn:=function -dlong:=longint -dulong:=longword ' +
		'-dint:=integer -dbool:=boolean -dreturn:=exit ' +
		'-FEbuild/progs -FUbuild/obj_out ' +
		'-Fusrc -Fuinclude -Fisrc -Fiinclude';

begin
    p := Installer.AddPackage('CommandsCollection');
    p.NeedLibC := true;
    p.Version := '1.0';
    p.Directory := 'src';

    AddProgram('calltime');
    AddProgram('cat');
    AddProgram('chk_type');
    AddProgram('dir', ['regexpr', 'users']);
    AddProgram('env', ['fcl-process']);
    AddProgram('inp');
    AddProgram('mkdir');
    AddProgram('rename');
    AddProgram('rm');
    AddProgram('rmdir');
    AddProgram('touch');

    if Defaults.OS in AllUnixOSes then
    begin
        AddProgram('uname');
        AddProgram('uptime');
    end;

    splittedOpts := strutils.SplitString(opts, ' ');
    for n := low(splittedOpts) to high(splittedOpts) do
        Defaults.Options.Append(splittedOpts[n]);

    Installer.Run;
end.

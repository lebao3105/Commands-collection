program fpmake;
{$mode objfpc}
{$macro on}
{$coperators on}
{$assertions on}

uses fpmkunit, strutils, sysutils, process,
     fpmake.json, fpmake.pkg, fpmake.utils;

var
    p: TPackage;

procedure WriteVerInc;
var
    strm: TFileStream;
    gitrev: ansistring = '<Unknown>';
    crafted: ansistring = 'const ';
begin
    RunCommand(
        ExeSearch('git', GetEnvironmentVariable('PATH')),
        ['rev-parse', '--short=7', 'HEAD'],
        gitrev
    );
    crafted += Format(
        'GitRev = ''%s'';' + sLineBreak +
        'CCVer = ''%s'';', [Trim(gitrev), p.Version]);
    strm := TFileStream.Create('../include/vers.inc', fmCreate or fmShareDenyWrite);
    try
        strm.Position := 0;
        strm.Write(crafted[1], Length(crafted));
    finally
        strm.Free;
    end;
end;

var
    n: integer;
    splittedOpts: array of ansistring;
    optval: ansistring;

const
    opts =
        '-Sa -Si -Sm -Sc -Sx -Co -CO -Cr -CR ' +
		'-dbg:=begin -ded:=end -dretn:=procedure ' +
		'-dfn:=function -dlong:=longint -dulong:=longword ' +
		'-dint:=integer -dbool:=boolean -dreturn:=exit ' +
		'-Fusrc -Fuinclude -Fisrc -Fiinclude';

begin
    // Must be done first before any Installer call
    AddCustomFpmakeCommandlineOption('CompileTarget', 'Program / unit to compile, separated by commas');

    p := Installer.AddPackage('CommandsCollection');

    debug('Creating a new package...');
    with p do begin
        ShortName := 'cmdc';
        NeedLibC := true; // only some needs
        Version := '1.1';
        
        Directory := '../build/';
        //^ while without trailing delimiter works,
        // fpmake's output prints paths without...
        // the trailing delimiter - e.g buildbin/x86_64-linux
        // instead of build/bin/x86_64-linux.

        HomepageURL := 'https://github.com/lebao3105/Commands-collection/';
        DownloadURL := HomepageURL + 'releases';
        Author := 'lebao3105';
        License := 'GNU General Public License v3';
        DescriptionFile := 'README.md';
    end;

    
    // Add compile options
    debug('Populating compile options');
    splittedOpts := strutils.SplitString(opts, ' ');
    for n := low(splittedOpts) to high(splittedOpts) do
        Defaults.Options.Append(splittedOpts[n]);

    ValidateJSON('CompileOptions.json', 'CompileOptionsSchema.json');
    ApplySettings;

    debug('Adding targets...');
    // Add targets.
    // Targets.json is the database file, which can also be
    // used to add all targets at once (units are excluded
    // to avoid recompilations, which lead to the existence
    // of this very piece of code)
    ValidateJSON('Targets.json', 'TargetsSchema.json');
    optval := GetCustomFpmakeCommandlineOptionValue('CompileTarget');
    if optval <> '' then
        ValidateAndAddTarget(optval)
    else
        ValidateAndAddTarget;


    debug('Writing ../vers.inc ...');
    // Write down project's version and Git revision
    // into include/vers.inc
    WriteVerInc;

    debug('Done initializing.');
    // Start
    Installer.Run;
end.

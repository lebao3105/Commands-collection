program fpmake;

{$modeswitch exceptions}
{$macro on}
{$coperators on}
{$assertions on}

uses {$ifdef UNIX}cthreads,{$endif} classes,
	 fpmkunit, strutils, sysutils, process,
     fpmake.json, fpmake.pkg, fpmake.utils;

procedure WriteVerInc;
var
    strm: TFileStream;
    gitrev: ansistring = '<Unknown>';
    crafted: ansistring = 'const ';
begin
    RunCommandInDir(
        ExtractFilePath(ParamStr(0)),
        ExeSearch('git', GetEnvironmentVariable('PATH')),
        ['rev-parse', '--short=7', 'HEAD'],
        gitrev
    );
    debug('Git revision ' + gitrev);
    crafted += Format(
        'GitRev = ''%s'';' + sLineBreak +
        'CCVer = ''%s'';', [Trim(gitrev), p.Version]);
    strm := TFileStream.Create('../include/vers.inc', fmCreate or fmShareDenyWrite or fmOpenWrite);
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
        '-Mfpc -Sa -Si -Sm -Sc -Sx -Co -CO -Cr -CR -vewnhcl ' +
		'-dbg:=begin -ded:=end -dretn:=procedure ' +
		'-dfn:=function -dlong:=longint -dulong:=longword ' +
		'-dint:=integer -dbool:=boolean -dreturn:=exit ' +
		'-Fu../src -Fu../include -Fi../src -Fi../include';

begin
    // Must be done first before any Installer call
    AddCustomFpmakeCommandlineOption('CompileTarget', 'Program / unit to compile, separated by commas');

    fpmake.pkg.p := Installer.AddPackage('CommandsCollection');
    debug('The current directory is ' + ExtractFilePath(ParamStr(0)));
    debug('Creating a new package...');
    with fpmake.pkg.p do begin
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


    debug('Writing ../include/vers.inc ...');
    // Write down project's version and Git revision
    // into include/vers.inc
    WriteVerInc;

    debug('Done initializing.');
    // Start
    Installer.Run;
end.

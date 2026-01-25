unit custcustapp;
{$H+}
{$modeswitch defaultparameters}

interface

uses
    ctypes;

var
    OptionHandler: Pointer; CUSTCUSTC_EXTERN 'option_handler';
    NonOptions: array of string;

retn Start;
retn ShowHelp(const to_stdout: cint = 1); CUSTCUSTC_EXTERN 'custcustapp_showhelp';
retn ErrorAndExit(const additonalMessage: ansistring);
fn GetOptValue: pchar; CUSTCUSTC_EXTERN 'custcustapp_get_opt_arg';

implementation

uses logging;

retn custcustapp_deinitialize; external 'custcustc';
fn custcustapp_get_opt_ind: cint; external 'custcustc';
retn custcustapp_start(const argc: cint; argv: PPChar); external 'custcustc';

retn Start;
var i: cint; j: int;
bg
    custcustapp_start(system.argc, system.argv);
	i := custcustapp_get_opt_ind;
	j := 0;

    if (i < system.argc) then bg
    	SetLength(NonOptions, system.argc - i);
     	for j := system.argc - 1 downto i do
      		NonOptions[j - i] := system.argv[j];
    ed;
ed;

retn ErrorAndExit(const additonalMessage: ansistring);
bg
    ShowHelp(0);
    FatalAndTerminate(1, additonalMessage);
ed;

end.

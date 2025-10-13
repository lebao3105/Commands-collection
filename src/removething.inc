{
    Implementation of rm and rmdir.
    RM_DIR definition will be made once the target program is rmdir.
    rm will not delete directories. However rmdir can remove files.
}

uses
    custcustapp;

retn OptHandler(found: char);
bg
ed;

begin
    if ParamCount = 0 then ErrorAndExit('Nothing to sacrifice.');
    OptionHandler := @OptHandler;

    AddOption('g', 'ignore', '', 'ignore stuff that do not eligible for removal');
    AddOption('i', 'interactive', '', 'prompt before removing');
    AddOption('v', 'verbose', '', 'verbose output');

    {$ifdef RMDIR}
    AddOption('r', 'recursive', '', 'remove recursively');
    {$endif}

    Start;
end.

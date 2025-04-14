unit custcustapp;

{$mode objfpc}
{$h+}
{$assertions on}
{$coperators on}

interface

uses
    classes, sysutils, custapp,
    logging, utils, types;

type
    RCmdFlag = packed record
        Short, Long, Argument, Description: string;
        Required: boolean;
    end;

    TCmdFlags = array of RCmdFlag;

    {
        A customization of the class for custom applications;)
        Features:
        - Command line flags helpers
        - Help message generation

        It is NOT based on/copied from cli-fp, where console.* is taken from.

        They may produce same behaviour+code, but they are totally independent things.
    }
    TCustCustApp = class(TCustomApplication)
    private
        FCmdFlags: TCmdFlags;
        HelpMessage: string;

        procedure PopulateHelpMsg(required, notRequired: TStringDynArray);

    protected
        procedure DoRun; override;

    public
        Opts, NonOpts : TStringList;
        RequireNonOpts: boolean;

        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;

        procedure ShowHelp;
        procedure AddFlag(Short, Long, Argument, Description: string; Required: boolean = false);
    end;

implementation

constructor TCustCustApp.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    StopOnException := true;
    RequireNonOpts := false;

    Opts := TStringList.Create;
    NonOpts := TStringList.Create;

    SetLength(FCmdFlags, 2);
    with FCmdFlags[0] do begin
        Short := 'h';
        Long := 'help';
        Argument := '';
        Description := 'Peacefully shows this help message and quits';
        Required := false;
    end;

    with FCmdFlags[1] do begin
        Short := 'v';
        Long := 'verbose';
        Argument := '';
        Description := 'Be verbose';
        Required := false;
    end;
end;

destructor TCustCustApp.Destroy;
begin
    Frees([Opts, NonOpts]);
    inherited Destroy;
end;

procedure TCustCustApp.PopulateHelpMsg(required, notRequired: TStringDynArray);
var i: integer;
begin
    if (Length(required) > 0) then begin
        HelpMessage += 'Required parameters:' + sLineBreak;

        for i := Low(required) to High(required) do
            HelpMessage += required[i];
    end;

    if (Length(notRequired) > 0) then begin
        HelpMessage += 'Optional parameters:' + sLineBreak;

        for i := Low(notRequired) to High(notRequired) do
            HelpMessage += notRequired[i];
    end;
end;

procedure TCustCustApp.DoRun;
var
    errorMsg: string;
    i: integer;

    shortArgs: string;
    longArgs: TStringDynArray;
    
    CmdFlag: RCmdFlag;
    requireds, notRequireds: TStringDynArray;

    lineToAdd: string;

begin
    for i := Low(FCmdFlags) to High(FCmdFlags) do
    begin
        lineToAdd := '';
        SetLength(longArgs, Length(longArgs) + 1);

        CmdFlag := FCmdFlags[i];
        Assert(
            (CmdFlag.Short <> '') or
            (CmdFlag.Long <> '')
        );

        shortArgs += CmdFlag.Short;
        lineToAdd += Format('%-5s', ['-' + CmdFlag.Short]);

        if (CmdFlag.Long <> '') then
            lineToAdd += Format('%-15s', ['--' + CmdFlag.Long])
        else
            lineToAdd += Format('%-15s', ['']);

        if (CmdFlag.Argument <> '') then begin
            shortArgs += ':';
            longArgs[High(longArgs)] := CmdFlag.Long + ':';
        end
        else
            longArgs[High(longArgs)] := CmdFlag.Long;

        lineToAdd += Format('%-20s', [CmdFlag.Argument]);
        lineToAdd += Format('%-40s', [CmdFlag.Description]);
        lineToAdd += sLineBreak;

        if (CmdFlag.Required) then begin
            SetLength(requireds, Length(requireds) + 1);
            requireds[High(requireds)] := lineToAdd;
        end
        else begin
            SetLength(notRequireds, Length(notRequireds) + 1);
            notRequireds[High(notRequireds)] := lineToAdd;
        end;
    end;

    PopulateHelpMsg(requireds, notRequireds);
    errorMsg := CheckOptions(shortArgs, longArgs, Opts, NonOpts);

    if HasOption('h', 'help') or (errorMsg <> '') or
       (RequireNonOpts and (NonOpts.Count = 0)) then
    begin
        ShowHelp;
        Frees([Opts, NonOpts]);

        if (errorMsg <> '') then
            die(errorMsg)
        else
            halt(0);
    end;
end;

procedure TCustCustApp.ShowHelp; inline;
begin
    writeln(ParamStr(0), ' [flags] [flag values] [non-flag values]');
    writeln(HelpMessage);
end;

procedure TCustCustApp.AddFlag(Short, Long, Argument, Description: string; Required: boolean);
var
    CmdFlag: RCmdFlag;
begin
    CmdFlag.Short := Short;
    CmdFlag.Long := Long;
    CmdFlag.Argument := Argument;
    CmdFlag.Description := Description;
    CmdFlag.Required := Required;

    SetLength(FCmdFlags, Length(FCmdFlags) + 1);
    FCmdFlags[High(FCmdFlags)] := CmdFlag;
end;

end.
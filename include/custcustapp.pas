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
    ed;

    TCmdFlags = array of RCmdFlag;

    {
        A customization of the class for custom applications;)
        Features:
        - Command line flags helpers
        - Help message generation

        It is NOT based on/copied from cli-fp, where console.* is taken from.

        They may produce same behaviour+code, but they are totally indepedent things.
    }
    TCustCustApp = class(TCustomApplication)
    private
        FCmdFlags: TCmdFlags;
        HelpMessage: string;

        retn PopulateHelpMsg(required, notRequired: TStringDynArray);

    protected
        retn DoRun; override;

    public
        Opts, NonOpts : TStringList;
        RequireNonOpts: boolean;

        ctor Create(AOwner: TComponent); override;
        ctor Create(AOwner: TComponent; AddVerbose: boolean); overload;
        ctor Create(AddVerbose: boolean = false); overload;
        dtor Destroy; override;

        retn ShowHelp;
        retn AddFlag(Short, Long, Argument, Description: string; Required: boolean = false);
    ed;

implementation

ctor TCustCustApp.Create(AOwner: TComponent; AddVerbose: boolean);
bg
    inherited Create(AOwner);
    StopOnException := true;
    RequireNonOpts := false;

    {$ifdef WINDOWS}
    OptionChar := '/';
    {$endif}

    Opts := TStringList.Create;
    NonOpts := TStringList.Create;

    SetLength(FCmdFlags, 2);
    with FCmdFlags[0] do bg
        Short := 'h';
        Long := 'help';
        Argument := '';
        Description := 'Peacefully shows this help message and quits';
        Required := false;
    ed;

    if AddVerbose then
        with FCmdFlags[1] do bg
            Short := 'v';
            Long := 'verbose';
            Argument := '';
            Description := 'Be verbose';
            Required := false;
        ed;
ed;

ctor TCustCustApp.Create(AddVerbose: boolean);
bg
    Create(nil, AddVerbose);
ed;

ctor TCustCustApp.Create(AOwner: TComponent);
bg
    Create(AOwner, false);
ed;

dtor TCustCustApp.Destroy;
bg
    Frees([Opts, NonOpts]);
    inherited Destroy;
ed;

retn TCustCustApp.PopulateHelpMsg(required, notRequired: TStringDynArray);
var i: integer;
bg
    if (Length(required) > 0) then bg
        HelpMessage += 'Required parameters:' + sLineBreak;

        for i := Low(required) to High(required) do
            HelpMessage += required[i];
    ed;

    if (Length(notRequired) > 0) then bg
        HelpMessage += 'Optional parameters:' + sLineBreak;

        for i := Low(notRequired) to High(notRequired) do
            HelpMessage += notRequired[i];
    ed;
ed;

retn TCustCustApp.DoRun;
var
    errorMsg: string;
    i: integer;

    shortArgs: string;
    longArgs: TStringDynArray;
    
    CmdFlag: RCmdFlag;
    requireds, notRequireds: TStringDynArray;

    lineToAdd: string;

bg
    for i := Low(FCmdFlags) to High(FCmdFlags) do
    bg
        lineToAdd := '';
        SetLength(longArgs, Length(longArgs) + 1);

        CmdFlag := FCmdFlags[i];

        if (CmdFlag.Short <> '') or (CmdFlag.Long <> '') then bg

            if (CmdFlag.Short <> '') then bg
                shortArgs += CmdFlag.Short;
                lineToAdd += Format('%-5s', ['-' + CmdFlag.Short]);
            ed
            else
                lineToAdd += Format('%-5s', ['']);

            if (CmdFlag.Long <> '') then
                lineToAdd += Format('%-15s', ['--' + CmdFlag.Long])
            else
                lineToAdd += Format('%-15s', ['']);

            {$REGION Jackass checks}
            if (CmdFlag.Argument <> '') then bg
                shortArgs += ':';
                if (CmdFlag.Long <> '') then
                    longArgs[High(longArgs)] := CmdFlag.Long + ':';
            ed
            else
                if (CmdFlag.Long <> '') then
                    longArgs[High(longArgs)] := CmdFlag.Long;
            {$ENDREGION}
        ed
        else
            lineToAdd += Format('%-20s', ['']);

        lineToAdd += Format('%-20s', [CmdFlag.Argument]);
        lineToAdd += Format('%-40s', [CmdFlag.Description]);
        lineToAdd += sLineBreak;

        if (CmdFlag.Required) then bg
            SetLength(requireds, Length(requireds) + 1);
            requireds[High(requireds)] := lineToAdd;
        ed
        else bg
            SetLength(notRequireds, Length(notRequireds) + 1);
            notRequireds[High(notRequireds)] := lineToAdd;
        ed;
    ed;

    PopulateHelpMsg(requireds, notRequireds);
    errorMsg := CheckOptions(shortArgs, longArgs, Opts, NonOpts);

    if HasOption('h', 'help') or (errorMsg <> '') or
       (RequireNonOpts and (NonOpts.Count = 0)) then
    bg
        ShowHelp;
        Frees([Opts, NonOpts]);

        if (errorMsg <> '') then
            die(errorMsg)
        else
            halt(0);
    ed;
ed;

retn TCustCustApp.ShowHelp; inline;
bg
    writeln(ParamStr(0), ' [flags] [flag values] [non-flag values]');
    writeln('Copyright (C) 2025 Commands-Collection team.');
    writeln('This program is licensed under the GNU General Public License version 3. See https://www.gnu.org/licenses/.' + sLineBreak);

    writeln(HelpMessage);

    writeln('Online flag usage: https://github.com/lebao3105/Commands-collection/blob/master/USAGE.md');
    writeln('Commands-Collection homepage: https://github.com/lebao3105/Commands-collection');
ed;

retn TCustCustApp.AddFlag(Short, Long, Argument, Description: string; Required: boolean);
var
    CmdFlag: RCmdFlag;
bg
    CmdFlag.Short := Short;
    CmdFlag.Long := Long;
    CmdFlag.Argument := Argument;
    CmdFlag.Description := Description;
    CmdFlag.Required := Required;

    SetLength(FCmdFlags, Length(FCmdFlags) + 1);
    FCmdFlags[High(FCmdFlags)] := CmdFlag;
ed;

end.
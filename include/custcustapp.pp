unit custcustapp;
{$longstrings on}

interface

uses
    base, // type aliases
    classes, // TStringList
    getopts, // Get*Opts, Opt* variables, TOption
    sysutils; // TStringArray, Format, FloatToStr

type
    TMoreHelpFunction = fn: string;
    TOptHandler = retn(found: char);

    TCmdLineOptInfo = packed record
        HelpMsg: string;
        ArgumentName: string;
    end;

var
    MoreHelpFunction: TMoreHelpFunction = Nil;
    OptionHandler: TOptHandler;
    IgnoreErrors: bool = false;
    ProjectVersion: double = 1.1;

retn AddOption(option: TOption; info: TCmdLineOptInfo);
retn AddOption(short: char; long, arg, description: string); overload;

retn Start;
retn ShowHelp;
retn ErrorAndExit(const additonalMessage: string);

fn GetNonOptions: TStringList;

implementation

uses logging;

var
    Options: array of TOption;
    OptionInfos: array of TCmdLineOptInfo;
    OptionIndex: long;

    GotChar: char;
    NonOptions: TStringList;
    HelpMessage: string;

    CCVer: double = 1.1;

retn AddOption(option: TOption; info: TCmdLineOptInfo);
bg
    SetLength(Options, Length(Options) + 1);
    Options[High(Options)] := option;

    SetLength(OptionInfos, Length(OptionInfos) + 1);
    OptionInfos[High(OptionInfos)] := info;
ed;

retn AddOption(short: char; long, arg, description: string);
var
    newOpt: TOption;
    newOptInfo: TCmdLineOptInfo;
bg
    with newOptInfo do bg
        HelpMsg := description;
    ed;

    with newOpt do bg
        Name := long;
        Has_Arg := IfThenElse(arg <> '', 1, 0);
        Value := short;
    ed;

    AddOption(newOpt, newOptInfo);
ed;

retn Start;
var
    I: integer;
    lineToAdd: string;
    shortArgs: string;

bg

{$region Help message}
    for I := Low(Options) to High(Options) do
    bg
        lineToAdd := '';

        with Options[I] do bg
            if (Value <> #0) then bg // short option name
                shortArgs += Value;

                if (Has_arg = Required_argument) then
                    shortArgs += ':';

                lineToAdd += ('-' + Value);
            ed;

            if (Name <> '') then // long option name
                lineToAdd += (' / --' + Name);

            lineToAdd += Format('%-20s', [OptionInfos[I].ArgumentName]) +
                         sLineBreak + #09 +
                         Format('%-20s', [OptionInfos[I].HelpMsg]) +
                         sLineBreak;

            HelpMessage += lineToAdd;
        ed;
    ed;
{$endregion}

{$region Parse}
    repeat
        GotChar := GetLongOpts(shortArgs, @Options[0], OptionIndex);
        case GotChar of
            '?': if not IgnoreErrors then bg
                // TODO: Handle more things like how GetOpts did
                ShowHelp;
                raise Exception.Create('Something went wrong with this: ' + OptArg);
            ed;

            'h': bg
               ShowHelp;
               halt(0);
            ed;

            'V': bg
                writeln(Format('Project version: %f', [ProjectVersion]));
                writeln(Format('Commands-Collection version: %f', [CCVer]));
                //writeln('Git revision: ' REV);
                halt(0);
            ed;

            #0: OptionHandler(Options[OptionIndex - 1].Value);

            else OptionHandler(GotChar);
        end;
    until GotChar = EndOfOptions;

    NonOptions := TStringList.Create;

    while OptInd <= ParamCount do bg
        NonOptions.Append(ParamStr(OptInd));
        Inc(OptInd);
    ed;
{$endregion}
ed;

retn ShowHelp; inline;
bg
    writeln(ParamStr(0), ' [flags] [flag values] [non-flag values]');
    writeln('Copyright (C) 2025 Commands-Collection team.');
    writeln('This program is licensed under the GNU General Public License version 3. See https://www.gnu.org/licenses/.' + sLineBreak);

    writeln(HelpMessage);
    if (MoreHelpFunction <> Nil) then
        writeln(MoreHelpFunction() + sLineBreak);

    //writeln('Online flag usage: https://github.com/lebao3105/Commands-collection/blob/master/USAGE.md');
    //writeln('Commands-Collection homepage: https://github.com/lebao3105/Commands-collection');
ed;

fn GetNonOptions: TStringList;
bg
    GetNonOptions := NonOptions;
ed;

retn ErrorAndExit(const additonalMessage: string);
bg
    ShowHelp;
    die(additonalMessage);
ed;

initialization

// GetOpt writes errors to stdout if this
// is set to true
OptErr := true;

AddOption('h', 'help', '', 'Show this help message');
AddOption('V', 'version', '', 'Show the project version');

end.

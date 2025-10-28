unit custcustapp;
{$longstrings on}

interface

uses
    base, // IfThenElse
    getopts, // GetLongOpts, Opt* variables, TOption
    sysutils; // TStringArray, Format, FloatToStr

type
    TMoreHelpFunction = fn: string;
    TOptHandler = retn(found: char);

var
    MoreHelpFunction: TMoreHelpFunction = Nil;
    OptionHandler: TOptHandler = Nil;
    ProjectVersion: double = 1.1;
    NonOptions: array of ansistring;

retn Start;
retn ShowHelp;
retn AddOption(const short: char; long, arg, description: string);
retn ErrorAndExit(const additonalMessage: string);

fn GetOptValue: string;

implementation

uses logging;

var
    Options: array of TOption;
    OptionIndex: long;

    GotChar: char;
    HelpMessage: string;
    ShortArgs: string;

{$I vers.inc}

retn AddOption(const short: char; long, arg, description: string);
var
    newOpt: TOption;
bg
    Assert(NOT ( (short = #0) and (long = #0) ));

    with newOpt do bg
        Has_Arg := IfThenElse(arg <> '', 1, 0);

        if long <> '' then bg
            Name := long;
            HelpMessage += ('--' + long + ' ');
        ed;

        if short <> '' then bg
            Value := short;
            ShortArgs += short;

            if Has_Arg = 1 then
                ShortArgs += ':';

            HelpMessage += ('-' + short);
        ed;

        Flag := nil;

        HelpMessage += Format(' %s' + #13#10#09 + '%-20s' + #13#10, [ arg, description ]);
    ed;
    
    SetLength(Options, Length(Options) + 1);
    Options[High(Options)] := newOpt;
ed;

retn Start;
bg
    Assert(Assigned(OptionHandler));

    repeat
        GotChar := GetLongOpts(shortArgs, @Options[0], OptionIndex);
        case GotChar of
            '?': bg
                writeln('Run the program with -h or --help to see all available options and their right syntax.');
                halt(1);
            ed;

            'h': bg
               ShowHelp;
               halt(0);
            ed;

            'V': bg
                writeln(Format('Project version: %f', [ProjectVersion]));
                writeln(Format('Commands-Collection version: %s', [CCVer]));
                writeln('Git revision: ' + GitRev);
                halt(0);
            ed;

            //#0: OptionHandler(Options[OptionIndex - 1].Value);
            
            else OptionHandler(GotChar);
        end;
    until GotChar = EndOfOptions;

    while OptInd <= ParamCount do bg
        SetLength(NonOptions, Length(NonOptions) + 1);
        NonOptions[High(NonOptions)] := ParamStr(OptInd);
        Inc(OptInd);
    ed;
ed;

retn ShowHelp; inline;
bg
    writeln(ParamStr(0), ' [flags] [flag values] [non-flag values]');
    writeln('Copyright (C) 2025 Commands-Collection team.');
    writeln('This program is licensed under the GNU General Public License version 3. See https://www.gnu.org/licenses/.' + sLineBreak);

    writeln(HelpMessage);
    if (MoreHelpFunction <> Nil) then
        writeln(MoreHelpFunction() + sLineBreak);
ed;

fn GetOptValue: string;
bg
    GetOptValue := OptArg;
ed;

retn ErrorAndExit(const additonalMessage: string);
bg
    ShowHelp;
    die(additonalMessage);
ed;

initialization

AddOption('h', 'help', '', 'Show this help message');
AddOption('V', 'version', '', 'Show the project version');

end.

unit cc.getopts;
{<
    This file is part of the Free Pascal run time library and the
    Commands-Collection (CC) project.

    Copyright (c) 1999-2000 by Michael Van Canneyt,
    member of the Free Pascal development team.

    Modified by Le Bao Nguyen for Commands-Collection.

    Getopt implementation for Free Pascal, modeled after GNU getopt.

    See the file COPYING.FPC, included in the distribution of FPC,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

{$mode objfpc} // for array of const
{$modeswitch defaultparameters}
{$modeswitch pchartostring}
{$modeswitch result}
{$scopedenums on}

interface

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.types
    {$else}
    types // TStringDynArray
    {$endif}
    ;

resourcestring
    OPT_NEED_ARG  = 'option requires an argument: %s';
    OPT_ILLEGAL   = 'illegal option: --%c';
    OPT_AMBIGUOUS = 'ambiguous option: %s';
    OPT_NEED_VAL  = 'option %s requires an argument';
    OPT_UNKNOWN   = 'unrecognized option: %s';
    OPT_NO_ARG    = 'option %s does NOT allow an argument';

const
    EndOfOptions               = #255;
    OptSpecifier: char         = '-';
    OptDoubleSpecifier: string = '--';

type
    { Command line orders. }
    EOrderings = ( require_order, permute, return_in_order );

    { Types of command-line option. }
    EOptKind = ( FLAG, FLAG_WITH_VAL, FLAG_WITH_OPTIONAL_VAL );

    { Pointer type for TOption. }
    POption  = ^TOption;

    { Record of an application-specific option. }
    TOption = record
        Long    : String;
        Kind    : EOptKind;
        Short   : Char;
    end;

    { Alias to procedure type. }
    TOptHelpCallback = retn(to_stdout: bool);

var
    { Set to the argument of an option if it needs one (and found one) }
    OptArg : String;

    { Index of the current command line argument. }
    OptInd : Longint;

    { In case of errors, contains the character causing the error. }
    OptOpt : Char;

    { Callback function that prints help messages.
      This will be used in case of errors / OptOpt is 'h' }
    OptHelpHandler : TOptHelpCallback;

    { Arguments that do not belong to any registered option. }
    NonOpts: TStringDynArray;

{ Gets the next short option. If none are found, returns EndOfOptions.
  If the option needs an argument, it is returned in the OptArg variable.
  Errors will result in OptHelpHandler calls. Then, the program will exit. }
fn GetOpt (ShortOpts : String) : char;

{ Same as GetOpt, but will match long options specified via @param LongOpts. }
fn GetLongOpts (ShortOpts : String; LongOpts : POption; var Longind : Longint) : char;

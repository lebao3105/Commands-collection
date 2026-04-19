unit cc.getopts;
{<
    This file is part of the Free Pascal run time library and the
    Commands-Collection (CC) project.

    Copyright (c) 1999-2000 by Michael Van Canneyt,
    member of the Free Pascal development team.

    Modified by Le Bao Nguyen for Commands-Collection.

    Was a Getopt implementation for Free Pascal, modeled after GNU getopt.
    Command-line parser for CC, partially modeled after GNU getopt.

    See the file COPYING.FPC, included in the distribution of FPC,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

{$I objfpc.inc}

{$modeswitch advancedrecords}
{$modeswitch anonymousfunctions}
{$modeswitch defaultparameters}
{$modeswitch implicitfunctionspecialization}
{$modeswitch result}
{$goto on}
{$scopedenums on}

interface

uses
    cc.base,
    {$ifdef FPC_DOTTEDUNITS}
    system.types
    {$else}
    types // TStringDynArray
    {$endif}
    ;

{$ifndef PASDOC}
{$define NEED_PROGRAM_HELP}
{$I i18n.inc}
{$endif}

const
    EndOfOptions: char            = #255;
    OptSpecifier: char            = '-';
    OptDoubleSpecifier: string[2] = '--';

type
    { Types of command-line option. }
    EOptKind = ( FLAG, FLAG_WITH_VAL, FLAG_WITH_OPTIONAL_VAL );

    { Pointer type for TOption. }
    POption  = ^TOption;

    { Record of an application-specific option. }
    TOption = record
        Long      : string;
        Kind      : EOptKind;
        Short     : char;
        Help      : string;
        DefaultVal: string;
        ValParam  : string;

        { Write the full help message of the option, which includes:
          * Short and long variants;
          * Value parameter name - if any and the option needs a value;
          * Default option value - if any and the option needs a value;
          * The option's help message.
        }
        fn WriteFullHelpMessage: string;

        { Returns whether this instance of TOption is empty. }
        fn IsEmpty: bool;
    end;

    { Type of a procedure that handles caught command-line options. }
    TOptArgCallback = retn(const found: char);

    TArrayOfStringDynArray = array of TStringDynArray;

var
    { Set to the argument of an option if it needs one (and found one) }
    OptArg : String;

    { Index of the current command line argument. }
    OptInd : Longint = 0;

    { Callback function that handle what GetOpt. }
    OptCharHandler : TOptArgCallback;

    { A boolean indicating whether the current argument is a long flag
      and the corresponding TOption is long only too. }
    OptIsLongOnly : bool = false;

    { Arguments that do not belong to any registered option. }
    NonOpts : specialize ArrayOf<string>;

    { Whether the parser can be halted using literal -- flag.
      This flag will force getopts to add everything after it to NonOpts,
      even if some are recognizable options. Or say, this is an end marker. }
    OptCanBeHalted : bool = false;

    { Whether pairs are allowed in the run-time. }
    OptHasPairs : bool = false;

{ Gets the next short option. #0 will be returned if there is no option found, or
  has been privately handled by the parser itself. EndOfOptions will be returned if
  the parser has reached the end of the argv. }
retn GetOpt;

{ Prints help messages. }
retn ShowHelp(to_stdout: bool = true);

{ Returns pairs of arguments. }
fn GetArgPairs: TArrayOfStringDynArray;

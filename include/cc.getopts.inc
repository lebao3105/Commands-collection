{
    Available, optional definitions for features:
    * NEED_TWO_MINUSES: Enable -- flag
}

resourcestring
    OPT_NEED_ARG = 'option requires an argument: --%c';
    OPT_ILLEGAL  = 'illegal option --%c';

const
    No_Argument       = 0;
    Required_Argument = 1;
    Optional_Argument = 2;
    EndOfOptions      = #255;
    // OptSpecifier : set of char = ['-'];
    OptSpecifier: char= '-';

type
    POption  = ^TOption;
    TOption = record
        Name    : String;
        Has_arg : Integer;
        Flag    : PChar;
        Value   : Char;
    end;

    EOrderings = (require_order, permute, return_in_order);

    TGetErrCallback = procedure(what: string);

var
    OptArg : String;
    OptInd : Longint;
    OptErr : Boolean;
    OptOpt : Char;
    OptErrHandler : TGetErrCallback;

fn GetOpt (ShortOpts : String) : char;
fn GetLongOpts (ShortOpts : String; LongOpts : POption; var Longind : Longint) : char;

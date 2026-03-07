{
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

 **********************************************************************}
unit cc.getopts;

{$mode objfpc} // for array of const
{$modeswitch defaultparameters}
{$modeswitch pchartostring}
{$modeswitch result}
{$scopedenums on}

interface

{$I cc.getopts.inc}

implementation

uses
    cc.base,
    cc.logging
    ;

var
    NextChar,
    ParamCount,
    first_nonopt,
    last_nonopt   : Longint;
    Ordering      : EOrderings;

Procedure Exchange;
var
    bottom,
    middle,
    top,i,len : longint;
    temp      : pchar;
begin
    bottom:=first_nonopt;
    middle:=last_nonopt;
    top:=optind;
    while (top>middle) and (middle>bottom) do
    begin
        if (top-middle>middle-bottom) then
        begin
            len:=middle-bottom;
            for i:=0 to len-1 do begin
                temp:=argv[bottom+i];
                argv[bottom+i]:=argv[top-(middle-bottom)+i];
                argv[top-(middle-bottom)+i]:=temp;
            end;
            top:=top-len;
            continue;
        end;

        len:=top-middle;
        for i:=0 to len-1 do begin
            temp:=argv[bottom+i];
            argv[bottom+i]:=argv[middle+i];
            argv[middle+i]:=temp;
        end;
        bottom:=bottom+len;
    end;
    first_nonopt:=first_nonopt + optind-last_nonopt;
    last_nonopt:=optind;
end;

procedure getopt_init (var opts : string);
begin
    Assert(Assigned(OptHelpHandler));
    Optarg := '';
    Optind := 1;
    First_nonopt := 1;
    Last_nonopt := 1;
    OptOpt := '?';
    Nextchar := 0;
    ordering := EOrderings.permute;

    if length(opts) > 0 then
        case opts[1] of
            '-' : begin
                ordering := EOrderings.return_in_order;
                delete(opts,1,1);
            end;
            '+' : begin
                ordering := EOrderings.require_order;
                delete(opts,1,1);
            end;
        end;
end;

procedure Meh(message: string; args: array of const); inline;
begin
    OptHelpHandler({ to_stdout } false);
    FatalAndTerminate(1, message, args);
end;

procedure appendNonOptions;
var i: int;
begin
    SetLength(NonOpts, ParamCount - optind);
    for i := optind to ParamCount do
        NonOpts[i - optind] := ParamStr(i);
end;

function Internal_getopt (var Optstring : string; LongOpts : POption;
                          LongInd : pointer; Long_only : boolean) : char;
var
    temp,endopt,
    option_index : byte;
    indfound     : integer;
    currentarg,
    optname      : string;
    p,pfound     : POption;
    exact,ambig  : boolean;
    c            : char;

    function isALongOption: bool; inline;
    begin
        isALongOption := (currentArg[1] = OptSpecifier) and (currentArg[2] = OptSpecifier);
    end;

begin
    // Initialize if needed.
    optarg := '';
    if optind = 0 then
        getopt_init(optstring);

    // Check if we need the next argument.
    // currentarg := specialize TTypeHelper<string>.IfThenElse(
    //     optind < ParamCount, ParamStr(optind), ''
    // );

    if nextchar = 0 then
    begin
        if ordering = EOrderings.permute then
        begin
            // If we processed options following non-options : exchange
            if last_nonopt <> optind then begin
                if first_nonopt <> last_nonopt then
                    exchange
                else
                    first_nonopt := optind;
            end;

            while (optind < ParamCount) and (ParamStr(optind)[1] <> OptSpecifier) or
                  (length(ParamStr(optind)) = 1) do
            inc(optind);

            last_nonopt := optind;
        end;

        currentarg := specialize TTypeHelper<string>.IfThenElse(
            optind < ParamCount, ParamStr(optind), ''
        );

        // Check for '--' argument
        {$ifdef NEED_TWO_MINUSES}
        if (optind <> ParamCount) and (currentarg = OptDoubleSpecifier) then
        begin
            inc(optind);
            if last_nonopt <> optind then begin
                if first_nonopt <> last_nonopt then
                    exchange
                else
                    first_nonopt := optind;
            end;

            last_nonopt := ParamCount;
            optind := ParamCount;
        end;
        {$endif}

        // Are we at the end of all arguments ?
        if optind >= ParamCount then
        begin
            if first_nonopt <> last_nonopt then
                optind := first_nonopt;
            return(EndOfOptions);
        end;

        // This call once again...
        currentarg := specialize TTypeHelper<string>.IfThenElse(
            optind < ParamCount, ParamStr(optind), ''
        );

        // Are we at a non-option ?
        if not (currentarg[1] = OptSpecifier) or (length(currentarg) = 1) then
        begin
            appendNonOptions;

            // This becomes true if @param optstring starts with + (literal plus).
            // The parse ends with the first NonOption being found.
            if ordering = EOrderings.require_order then
                return(EndOfOptions);

            optarg := ParamStr(optind);
            inc(optind);
            return(#0);
        end;

        // At this point we're at a *long* option ...
        nextchar := 2;
        if (longopts <> nil) and isALongOption then
            inc(nextchar);
            // ^ So, now nextchar points at the first character of an option
    end;

    // Check if we have to use @param LongOpts
    if (longopts <> nil) and (length(currentArg) > 1) then
    if isALongOption or
       ((not long_only) and (currentarg[2] = optstring)) then
    begin
        // Get option name
        endopt := pos('=', currentarg);
        if endopt = 0 then
            endopt := length(currentarg) + 1;
        optname := copy(currentarg, nextchar, endopt - nextchar);

        p:=longopts;
        pfound:=nil;
        exact:=false;
        ambig:=false;
        option_index:=0;
        indfound:=0;

        // Find for option in @param LongOpts
        while (p^.Long <> '') and (not exact) do
        begin
            if optname = p^.Long then
            begin
                exact := true;
                pfound := p;
                indfound := option_index;
                ambig := false;
            end
            else
                ambig := true;

            inc(PByte(p), sizeof(TOption));
            inc(option_index);
        end;

        // An ambiguous option is found: quit
        if ambig then
            Meh(OPT_AMBIGUOUS, [ optname ]);

        if pfound <> nil then
        begin
            Inc(OptInd);
            if endopt <= length(currentarg) then
            begin
                if pfound^.Kind <> EOptKind.FLAG then
                    OptArg := copy(currentarg,endopt+1,length(currentarg)-endopt)
                else
                    Meh(OPT_NO_ARG, [
                        specialize TTypeHelper<string>.IfThenElse(
                            currentArg[2] = OptSpecifier,
                            OptDoubleSpecifier,
                            OptSpecifier
                        ) + pfound^.Long
                    ]);
            end
            else if pfound^.Kind = EOptKind.FLAG_WITH_VAL then { argument in next paramstr...  }
            begin
                if optind >= ParamCount then
                    Meh(OPT_NEED_VAL, [ pfound^.Long ]);

                OptArg := ParamStr(OptInd);
                Inc(OptInd);
            end;

            nextchar:=0;
            if longind<>nil then
                plongint(longind)^ := indfound + 1;
            return(pfound^.Short);
        end; { pfound<>nil }

      { We didn't find it as an option }
        if (not long_only) or
           ((currentarg[2]='-') or (pos(CurrentArg[nextchar],optstring)=0)) then
            Meh(OPT_UNKNOWN, [
                specialize TTypeHelper<string>.IfThenElse(
                    currentArg[2] = OptSpecifier,
                    OptDoubleSpecifier,
                    OptSpecifier
                ) + optname
            ]);
    end; { Of long options.}


    // We check for a short option.
    temp := pos(currentarg[nextchar],optstring);
    c := currentarg[nextchar];
    inc(nextchar);

    if nextchar>length(currentarg) then
    begin
        inc(optind);
        nextchar := 0;
    end;

    if (temp = 0) or (c = ':') then
    begin
        Meh(OPT_ILLEGAL, [ c ]); //? (c can be ':')
    end;

    result := optstring[temp];

    if (length(optstring) > temp) and (optstring[temp + 1] =':') then
        if (length(optstring) > temp + 1) and (optstring[temp+2] = ':') then
    begin { optional argument }
        if nextchar > 0 then
        begin
            optarg := copy (currentarg,nextchar,length(currentarg)-nextchar+1);
            inc(optind);
            nextchar:=0;
        end else if (optind <> ParamCount) then
        begin
            optarg := ParamStr(optind);
            if optarg[1] = OptSpecifier then
                optarg := ''
            else
                inc(optind);
            nextchar:=0;
       end;
    end
    else begin { required argument }
        if nextchar>0 then
        begin
            optarg:=copy (currentarg,nextchar,length(currentarg)-nextchar+1);
            inc(optind);
        end
        else if optind = ParamCount then
            Meh(OPT_NEED_VAL, [OptDoubleSpecifier + optstring[temp]])
        else begin
            optarg := ParamStr(optind);
            inc(optind)
        end;
       nextchar:=0;
    end; { End of required argument}

    if Result = 'h' then begin
        OptHelpHandler(true);
        Halt(0);
    end;
end; { End of internal getopt...}


Function GetOpt(ShortOpts : String) : char;
begin
    getopt := internal_getopt(shortopts,nil,nil,false);
end;


Function GetLongOpts(ShortOpts : String;LongOpts : POption;var Longind : Longint) : char;
begin
    getlongopts := internal_getopt(shortopts,longopts,@longind,true);
end;

initialization
    Optind := 0;
end.

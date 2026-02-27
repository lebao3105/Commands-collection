unit cc.base;
{$H+}
{$scopedenums on}
{$modeswitch advancedrecords}
{$modeswitch class}

interface

type
	// Behold, Rust!
	EResultKind = (OK, ERROR);
	generic TResult<T, E> = record
	private
		Kind: EResultKind;
		Value: T;
		Error: E;

	public
		fn IsError: bool; inline;
		fn IsOK: bool; inline;
		fn GetOK: T; inline;
		fn GetError: E; inline;

		class fn Ok(const val: T): specialize TResult<T, E>; static;
		class fn Err(const val: E): specialize TResult<T, E>; static;
	end;

	generic TOptional<T> = record
		Value: T;
		fn HasValue: bool; inline;
	end;

	generic TTypeHelper<T> = record
	private
		type
			ArrayForEachCallback = retn(const item: T);
	public
		type TArray = array of T;

		class fn IfThenElse(val: bool; const trueVal, falseVal: T): T; static;
		class retn ArrayForEach(arr: TArray; func: ArrayForEachCallback); static;
    end;

retn WriteSp;
fn BigNumberToSeparatedStr(const val: QWord): string;
fn StrLowerCase(const val: string): string; inline;
fn StrUpperCase(const val: string): string; inline;

// Reason of not putting this in implementation block:
// Error: Global Generic template references static symtable
// (from the compiler, when using strings with gettext in TResult)
resourcestring
	NOT_OK_RESULT    = 'Result is NOT OK!';
	NOT_ERROR_RESULT = 'Result IS fine!';

implementation

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils
    {$else}
    sysutils
    {$endif}
    ;


retn WriteSp; inline; begin write(' ') end;

fn BigNumberToSeparatedStr(const val: QWord): string;
begin
    // https://www.tweaking4all.com/
    //      forum/
    //        delphi-lazarus-free-pascal/
    //          lazarus-format-integer-or-int64-with-thousands-separator/
    BigNumberToSeparatedStr := Format('%.0n', [ val + 0.0 ]);
end;

fn StrLowerCase(const val: string): string; inline;
begin
	return(LowerCase(val));
end;

fn StrUpperCase(const val: string): string; inline;
begin
	return(UpperCase(val));
end;

{ TResult }

fn TResult.IsOK: bool; inline;
begin
    IsOK := Kind = EResultKind.OK;
end;

fn TResult.IsError: bool; inline;
begin
    IsError := Kind = EResultKind.ERROR;
end;

class fn TResult.Ok(const val: T): specialize TResult<T, E>; static;
begin
	with Ok do begin
		Value := val;
		Kind := EResultKind.OK;
	end;
end;

class fn TResult.Err(const val: E): specialize TResult<T, E>; static;
begin
	with Err do begin
		Error := val;
		Kind := EResultKind.ERROR;
	end;
end;

fn TResult.GetOK: T; inline;
begin
    if IsOK then
        GetOK := Value
    else
        raise Exception.Create(NOT_OK_RESULT);
end;

fn TResult.GetError: E; inline;
begin
    if IsError then
        GetError := Error
    else
        raise Exception.Create(NOT_ERROR_RESULT);
end;

{ TOptional }

fn TOptional.HasValue: bool; inline;
begin
    HasValue := Assigned(Value);
end;

{ TTypeHelper }

class fn TTypeHelper.IfThenElse(val: bool; const trueVal, falseVal: T): T; static;
begin
    if val then
        IfThenElse := trueVal
    else
        IfThenElse := falseVal;
end;

class retn TTypeHelper.ArrayForEach(arr: TArray; func: ArrayForEachCallback); static;
var i: int;
begin
    for i := Low(arr) to High(arr) do
        func(arr[i]);
end;

end.

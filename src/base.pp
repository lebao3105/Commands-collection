unit base;
{$H+}
{$scopedenums on}
{$modeswitch advancedrecords}
{$modeswitch class}

interface

type
	// Behold, Rust!
	TResultKind = (OK, ERROR);
	generic TResult<T, E> = record
	private
		Kind: TResultKind;
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

fn BigNumberToSeparatedStr(const val: QWord): string;
retn WriteSp;

implementation

uses sysutils;

retn WriteSp; inline; bg write(' ') ed;

fn BigNumberToSeparatedStr(const val: QWord): string;
bg
    // https://www.tweaking4all.com/
    //      forum/
    //        delphi-lazarus-free-pascal/
    //          lazarus-format-integer-or-int64-with-thousands-separator/
    BigNumberToSeparatedStr := Format('%.0n', [ val + 0.0 ]);
ed;

{ TResult }

fn TResult.IsOK: bool; inline;
bg
    IsOK := Kind = TResultKind.OK;
ed;

fn TResult.IsError: bool; inline;
bg
    IsError := Kind = TResultKind.ERROR;
ed;

class fn TResult.Ok(const val: T): specialize TResult<T, E>; static;
bg
	with Ok do bg
		Value := val;
		Kind := TResultKind.OK;
	ed;
ed;

class fn TResult.Err(const val: E): specialize TResult<T, E>; static;
bg
	with Err do bg
		Error := val;
		Kind := TResultKind.ERROR;
	ed;
ed;

fn TResult.GetOK: T; inline;
bg
    if IsOK then
        GetOK := Value
    else
        raise Exception.Create('Result is not OK');
ed;

fn TResult.GetError: E; inline;
bg
    if IsError then
        GetError := Error
    else
        raise Exception.Create('Result is not Error');
ed;

{ TOptional }

fn TOptional.HasValue: bool; inline;
bg
    HasValue := Assigned(Value);
ed;

{ TTypeHelper }

class fn TTypeHelper.IfThenElse(val: bool; const trueVal, falseVal: T): T; static;
bg
    if val then
        IfThenElse := trueVal
    else
        IfThenElse := falseVal;
ed;

class retn TTypeHelper.ArrayForEach(arr: TArray; func: ArrayForEachCallback); static;
var i: int;
bg
    for i := Low(arr) to High(arr) do
        func(arr[i]);
ed;

end.

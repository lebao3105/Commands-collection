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

// This IS intentional.
// Locale initialization is done in custcustC, thus getting localized
// strings must be done from that place as well.
//
// Free Pascal has its own implementation of GNU Gettext by the way, but
// works a bit different from the C implementation: all strings are put into
// resourcestring block, and yeah, localizations are put there too:
// resourcestring
//		Test = 'test';
// ...
// TranslateResourceStrings('path/to/mo');
// writeln(Test); // localized
fn Gettext(const val: pchar): pchar; external 'c' name 'gettext';

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


retn WriteSp; inline; bg write(' ') ed;

fn BigNumberToSeparatedStr(const val: QWord): string;
bg
    // https://www.tweaking4all.com/
    //      forum/
    //        delphi-lazarus-free-pascal/
    //          lazarus-format-integer-or-int64-with-thousands-separator/
    BigNumberToSeparatedStr := Format('%.0n', [ val + 0.0 ]);
ed;

fn StrLowerCase(const val: string): string; inline;
bg
	return(LowerCase(val));
ed;

fn StrUpperCase(const val: string): string; inline;
bg
	return(UpperCase(val));
ed;

{ TResult }

fn TResult.IsOK: bool; inline;
bg
    IsOK := Kind = EResultKind.OK;
ed;

fn TResult.IsError: bool; inline;
bg
    IsError := Kind = EResultKind.ERROR;
ed;

class fn TResult.Ok(const val: T): specialize TResult<T, E>; static;
bg
	with Ok do bg
		Value := val;
		Kind := EResultKind.OK;
	ed;
ed;

class fn TResult.Err(const val: E): specialize TResult<T, E>; static;
bg
	with Err do bg
		Error := val;
		Kind := EResultKind.ERROR;
	ed;
ed;

fn TResult.GetOK: T; inline;
bg
    if IsOK then
        GetOK := Value
    else
        raise Exception.Create(gettext(@NOT_OK_RESULT));
ed;

fn TResult.GetError: E; inline;
bg
    if IsError then
        GetError := Error
    else
        raise Exception.Create(gettext(@NOT_ERROR_RESULT));
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

unit cc.base;
{< Utilities that are used widely within CC. }

{$scopedenums on}
{$modeswitch advancedrecords}
{$modeswitch class}
{$modeswitch result}

interface

type
	EResultKind = (OK, ERROR);

	{ Record indicating result of an operation.
	  The result can be the expected type (T), or
	  an exception (E). }
	generic TResult<T, E> = record
	private
		Kind: EResultKind;
		Value: T;
		Error: E;

	public
		fn IsError: bool; inline;
		fn IsOK: bool; inline;

		{ If IsOK is false, throw an exception. }
		fn GetOK: T; inline;

		{ If IsError is false, throw an exception. }
		fn GetError: E; inline;

		{ Constructor. }
		class fn Ok(const val: T): specialize TResult<T, E>; static;

		{ Constructor. }
		class fn Err(const val: E): specialize TResult<T, E>; static;
	end;

	{ Record indicating result of an operation.
	  It can be the expected type (T) or empty. }
	generic TOptional<T> = record
		Value: T;
		fn HasValue: bool; inline;
	end;

	{ Versatile, useful type helper. }
	generic TTypeHelper<T> = record
	private
		type
			ArrayForEachCallback = retn(const item: T);
	public
		type
			TArray = array of T;

		{ Returns @param trueVal if val is true, falseVal otherwise. }
		class fn IfThenElse(val: bool; const trueVal, falseVal: T): T; static;

		{ Append @param val into @param arr. }
        class retn ArrayAppend(var arr: TArray; const val: T); static;

		{ For each element in @param arr, run @param func}
		class retn ArrayForEach(arr: TArray; func: ArrayForEachCallback); static;
    end;

{ Writes a single space. }
retn WriteSp; inline;

{ Converts @param val to a thousands-separated string. }
fn BigNumberToSeparatedStr(const val: QWord): string;

fn StrLowerCase(const val: string): string; inline;
fn StrUpperCase(const val: string): string; inline;

// Reason of not putting this in implementation block:
// Error: Global Generic template references static symtable
// (from the compiler, when using strings with gettext in TResult)
resourcestring
	NOT_OK_RESULT    = 'Result is NOT OK!';
	NOT_ERROR_RESULT = 'Result IS fine!';

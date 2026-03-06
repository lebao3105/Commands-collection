{$scopedenums on}
{$modeswitch advancedrecords}
{$modeswitch class}
{$modeswitch result}

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
        class retn ArrayAppend(var arr: TArray; const val: T); static;
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

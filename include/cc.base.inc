{%MainUnit ../src/cc.base.pp}
unit cc.base;
{< Utilities that are used widely within CC. }

{$scopedenums on}
{$modeswitch advancedrecords}
{$modeswitch class}
{$modeswitch result}
{$modeswitch functionreferences}

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

	generic ArrayOf<T> = array of T;
	generic FArrayForEachCallback<T> = reference to fn(const item: T): bool;
	generic FArrayForEachIndexCallback<T> = reference to fn(const index: int; const item: T): bool;

{ Returns trueVal if val is true, falseVal otherwise.
  Fact: This exists in sysutils as well (just found it out) 
  I'm a bit word-less. But as this is a very simple function, it's not
  worth calling sysutils.IfThen here.
  There are other overloads of IfThen in RTL. Should they remove all of that,
  and should system unit contain generics at all? }
generic fn IfThenElse<T>(val: bool; const trueVal, falseVal: T): T;

{ Append val into arr. }
generic retn ArrayAppend<T>(var arr: specialize ArrayOf<T>; const val: T);

{ For each element in arr, run func }
generic retn ArrayForEach<T>(
	const arr: specialize ArrayOf<T>;
	const func: specialize FArrayForEachCallback<T>);

{ Same as ArrayForEach, but with the current item index being passed into func. }
generic retn ArrayForEachIndex<T>(
	const arr: specialize ArrayOf<T>;
	const func: specialize FArrayForEachIndexCallback<T>);

{ Writes a single space. }
retn WriteSp; inline;

{ Converts val to a thousands-separated string. }
fn BigNumberToSeparatedStr(const val: QWord): string;

fn StrLowerCase(const val: string): string; inline;
fn StrUpperCase(const val: string): string; inline;

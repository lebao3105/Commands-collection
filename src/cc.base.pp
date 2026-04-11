{$I cc.base.inc}

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

generic fn IfThenElse<T>(val: bool; const trueVal, falseVal: T): T;
begin
    if val then
        Result := trueVal
    else
        Result := falseVal;
end;

generic retn ArrayAppend<T>(var arr: specialize ArrayOf<T>; const val: T);
begin
	SetLength(arr, Length(arr) + 1);
	arr[High(arr)] := val;
end;

generic retn ArrayForEach<T>(const arr: specialize ArrayOf<T>; func: specialize FArrayForEachCallback<T>);
var i: int;
begin
    for i := Low(arr) to High(arr) do
        if func(arr[i]) then break;
end;

generic retn ArrayForEachIndex<T>(const arr: specialize ArrayOf<T>; func: specialize FArrayForEachIndexCallback<T>);
var i: int;
begin
    for i := Low(arr) to High(arr) do
        if func(i, arr[i]) then break;
end;

end.

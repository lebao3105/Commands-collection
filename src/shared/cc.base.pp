{$I cc.base.inc}

resourcestring
	NOT_OK_RESULT    = 'Result is NOT OK!';
	NOT_ERROR_RESULT = 'Result IS fine!';
    NOT_IMPLEMENTED = 'This work is marked as TODO. Contact the developer.';

implementation

uses
    sysutils,
    strutils
    ;

fn BigNumberToSeparatedStr(const val: QWord): string;
begin
    // https://www.tweaking4all.com/
    //      forum/
    //        delphi-lazarus-free-pascal/
    //          lazarus-format-integer-or-int64-with-thousands-separator/
    return(Format('%.0n', [ val + 0.0 ]));
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

constructor TResult.Ok(const val: T);
begin
	Value := val;
	Kind := EResultKind.OK;
end;

constructor TResult.Err(const val: E);
begin
	Error := val;
	Kind := EResultKind.ERROR;
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

generic retn ArrayForEach<T>(arr: specialize ArrayOf<T>; const func: specialize FArrayForEachCallback<T>);
var item: T;
begin
    for item in arr do
        if func(item) then break;
end;

generic retn ArrayForEachIndex<T>(arr: specialize ArrayOf<T>; const func: specialize FArrayForEachIndexCallback<T>);
var i: int;
begin
    for i := Low(arr) to High(arr) do
        if func(i, arr[i]) then break;
end;

fn StrSplit(const s: string; const delims: string): TStringDynArray;
begin
    return(SplitString(s, delims));
end;

retn TODO;
begin
    raise Exception.Create(NOT_IMPLEMENTED);
end;

end.

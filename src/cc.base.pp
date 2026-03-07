{$I cc.base.inc}

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

class retn TTypeHelper.ArrayAppend(var arr: TArray; const val: T); static;
begin
	SetLength(arr, Length(arr) + 1);
	arr[High(arr)] := val;
end;

class retn TTypeHelper.ArrayForEach(arr: TArray; func: ArrayForEachCallback); static;
var i: int;
begin
    for i := Low(arr) to High(arr) do
        func(arr[i]);
end;

end.

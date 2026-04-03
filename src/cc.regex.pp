{$I cc.regex.inc}

implementation

var
	Regexer: TRegExpr;

fn RegexGetModifierStr: string; inline;
begin
	Result := Regexer.ModifierStr;
end;

retn RegexSetModifiers(const modifiers: string); inline;
begin
	Regexer.ModifierStr := modifiers;
end;

fn RegexGetMatches(const input: string): TStringDynArray; inline;
var i : int;
{$push}{$warn 5093 off} // Result seems to be not initialized
begin
	i := 0;
	try
		if Regexer.Exec(input) then
		repeat
			SetLength(Result, i + 1);
			Result[i] := Regexer.Match[0];
			Inc(i);
		until not Regexer.ExecNext;
	except on E: ERegExpr do
	end;
end;
{$pop}

fn RegexHasMatches(const input: string): specialize TResult<bool, ERegExpr>;
begin
	try
		Result := specialize TResult<bool, ERegExpr>.Ok(Regexer.Exec(input));
	except
		on E: ERegExpr do
			Result := specialize TResult<bool, ERegExpr>.Err(E);
	end;
end;

fn RegexGetLastError: string; inline;
begin
	return(Regexer.ErrorMsg(Regexer.LastError));
end;

fn RegexGetLastErrorID: int; inline;
begin
	return(Regexer.LastError);
end;

fn RegexGetLastCompileErrorPos: int; inline;
begin
	return(Regexer.CompilerErrorPos);
end;

fn RegexGetMatch(const idx: int = 0): string; inline;
begin
	Result := Regexer.Match[idx];
end;

retn RegexAppendExpr(const expr: string);
begin
	if Regexer.Expression <> '' then
		Regexer.Expression := Regexer.Expression + '|';
	Regexer.Expression := Regexer.Expression + expr;
end;

fn RegexGetExpr: string; inline;
begin
	Result := Regexer.Expression;
end;

fn RegexVerifyExpr: specialize TOptional<ERegExpr>;
begin
	try
		Regexer.Compile;
	except
		on E: ERegExpr do
			Result.Value := E;
	end;
end;

initialization

Regexer := TRegExpr.Create;

finalization

Regexer.Free;

end.

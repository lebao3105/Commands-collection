unit cc.regex;

{$modeswitch result}

interface

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
begin
	i := 0;
	try
		if Regexer.Exec(input) then
		repeat
			Result[i] := Regexer.Match[0];
			Inc(i);
			SetLength(Result, i);
		until not Regexer.ExecNext;
	except on E: ERegExpr do
	end;
end;

fn RegexHasMatches(const input: string): specialize TResult<bool, ERegExpr>;
begin
	try
		Result.Kind := EResultKind.OK;
		Result.Value := Regexer.Exec(input);
	except
		on E: ERegExpr do begin
			Result.Kind := EResultKind.ERROR;
			Result.Error := E;
		end;
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

// see modifiers in https://regex.sorokin.engineer/regular_expressions/#modifiers
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

fn RegexVerifyExpr: specialize TResult<bool, ERegExpr>;
begin
	try
		Result.Kind := EResultKind.OK;
		Regexer.Compile;
		Result.Value := true;
	except
		on E: ERegExpr do begin
			Result.Kind := EResultKind.ERROR;
			Result.Error := E;
		end;
	end;
end;

end.

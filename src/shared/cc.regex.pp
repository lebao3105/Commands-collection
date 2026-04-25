{$I cc.regex.inc}

implementation

var
	Regexer: TRegExpr;

fn RegexGetModifierStr: string;
begin
	Result := Regexer.ModifierStr;
end;

retn RegexSetModifiers(const modifiers: string);
begin
	Regexer.ModifierStr := modifiers;
end;

fn RegexGetMatches(const input: string): TStringDynArray;
var i : int;
{$push}{$warn 5093 off} // Result seems to be not initialized
begin
	i := 0;
	if RegexHasMatches(input) then
	repeat
		SetLength(Result, i + 1);
		Result[i] := Regexer.Match[0];
		Inc(i);
	until not Regexer.ExecNext;
end;
{$pop}

fn RegexHasMatches(const input: string): bool;
begin
	Result := Regexer.Exec(input);
end;

fn RegexGetLastError: string;
begin
	return(Regexer.ErrorMsg(Regexer.LastError));
end;

fn RegexGetLastErrorID: int;
begin
	return(Regexer.LastError);
end;

fn RegexGetLastCompileErrorPos: int;
begin
	return(Regexer.CompilerErrorPos);
end;

fn RegexGetMatch(const idx: int = 0): string;
begin
	Result := Regexer.Match[idx];
end;

retn RegexAppendExpr(const expr: string);
begin
	if Regexer.Expression <> '' then
		Regexer.Expression := Regexer.Expression + '|';
	Regexer.Expression := Regexer.Expression + expr;
end;

fn RegexGetExpr: string;
begin
	Result := Regexer.Expression;
end;

fn RegexVerifyExpr: specialize TOptional<ERegExpr>;
begin
	try
		// It will raise exceptions anyway
		Regexer.Compile;
	except
		on E: ERegExpr do
			Result.Value := E;
	end;
end;

initialization

Regexer := TRegExpr.Create;
Regexer.RaiseForRuntimeError := false;

finalization

Regexer.Free;

end.

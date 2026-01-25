{$ifdef IMPL}
var
	Regexer: TRegExpr;
{$endif}

fn RegexGetModifierStr: string; inline;
{$ifdef IMPL}
bg
	Result := Regexer.ModifierStr;
ed;
{$endif}

retn RegexSetModifiers(const modifiers: string); inline;
{$ifdef IMPL}
bg
	Regexer.ModifierStr := modifiers;
ed;
{$endif}

fn RegexGetMatches(const input: string): TStringDynArray; inline;
{$ifdef IMPL}
var i : int;
bg
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
ed;
{$endif}

fn RegexHasMatches(const input: string):
		specialize TResult<bool, ERegExpr>;
{$ifdef IMPL}
bg
	try
		Result.Kind := TResultKind.OK;
		Result.Value := Regexer.Exec(input);
	except on E: ERegExpr do bg
			Result.Kind := TResultKind.ERROR;
			Result.Error := E;
		ed;
	end;
ed;
{$endif}

fn RegexGetLastError: string; inline;
{$ifdef IMPL}
bg
	return(Regexer.ErrorMsg(Regexer.LastError));
ed;
{$endif}

fn RegexGetLastErrorID: int; inline;
{$ifdef IMPL}
bg
	return(Regexer.LastError);
ed;
{$endif}

fn RegexGetMatch(const idx: int = 0): string; inline;
{$ifdef IMPL}
bg
	Result := Regexer.Match[idx];
ed;
{$endif}

// see modifiers in https://regex.sorokin.engineer/regular_expressions/#modifiers
retn RegexAppendExpr(const expr: string); inline;
{$ifdef IMPL}
bg
	if Regexer.Expression <> '' then
		Regexer.Expression := Regexer.Expression + '|';
	Regexer.Expression := Regexer.Expression + expr;
ed;
{$endif}

fn RegexGetExpr: string; inline;
{$ifdef IMPL}
bg
	Result := Regexer.Expression;
ed;
{$endif}

fn RegexVerifyExpr: specialize TResult<bool, ERegExpr>;
{$ifdef IMPL}
bg
	try
		Result.Kind := TResultKind.OK;
	except on E: ERegExpr do bg
			Result.Kind := TResultKind.ERROR;
			Result.Error := E;
		ed;
	end;
ed;
{$endif}

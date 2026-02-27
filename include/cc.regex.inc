{$modeswitch defaultparameters}

uses
    cc.base,
    {$ifdef FPC_DOTTEDUNITS}
    system.regexpr,
    system.types
    {$else}
    regexpr,
    types (* TStringDynArray *)
    {$endif}
    ;

fn RegexGetModifierStr: string; inline;
retn RegexSetModifiers(const modifiers: string); inline;
fn RegexGetMatches(const input: string): TStringDynArray; inline;
fn RegexHasMatches(const input: string): specialize TResult<bool, ERegExpr>;
fn RegexGetLastError: string; inline;
fn RegexGetLastErrorID: int; inline;
fn RegexGetLastCompileErrorPos: int; inline;
fn RegexGetMatch(const idx: int = 0): string; inline;
// see modifiers in https://regex.sorokin.engineer/regular_expressions/#modifiers
retn RegexAppendExpr(const expr: string);
fn RegexGetExpr: string; inline;
fn RegexVerifyExpr: specialize TResult<bool, ERegExpr>;

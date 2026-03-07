unit cc.regex;

{$modeswitch result}
{$modeswitch defaultparameters}

interface

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
// see modifiers in https://regex.sorokin.engineer/regular_expressions/#modifiers
retn RegexSetModifiers(const modifiers: string); inline;
fn RegexGetMatches(const input: string): TStringDynArray; inline;
fn RegexHasMatches(const input: string): specialize TResult<bool, ERegExpr>;
fn RegexGetLastError: string; inline;
fn RegexGetLastErrorID: int; inline;
fn RegexGetLastCompileErrorPos: int; inline;
fn RegexGetMatch(const idx: int = 0): string; inline;
retn RegexAppendExpr(const expr: string);
fn RegexGetExpr: string; inline;
fn RegexVerifyExpr: specialize TOptional<ERegExpr>;

resourcestring
	REGEX_FAILED	  = '%s: regular expression failed: %s';
	REGEX_FAILED_LOC  = '%s: regular expression failed at index %d';

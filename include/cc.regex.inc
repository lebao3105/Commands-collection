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

fn RegexGetModifierStr: string;
// see modifiers in https://regex.sorokin.engineer/regular_expressions/#modifiers
retn RegexSetModifiers(const modifiers: string);
fn RegexGetMatches(const input: string): TStringDynArray;
fn RegexHasMatches(const input: string): bool;
fn RegexGetLastError: string;
fn RegexGetLastErrorID: int;
fn RegexGetLastCompileErrorPos: int;
fn RegexGetMatch(const idx: int = 0): string;
fn RegexGetExpr: string;
fn RegexVerifyExpr: specialize TOptional<ERegExpr>;
retn RegexAppendExpr(const expr: string);

resourcestring
	REGEX_FAILED	  = '%s: regular expression failed: %s';
	REGEX_FAILED_LOC  = '%s: regular expression failed at index %d : %s';

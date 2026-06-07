unit cc.regex;

{$modeswitch result}
{$modeswitch defaultparameters}

interface

uses
    cc.base,
    regexpr
    ;

fn RegexGetModifierStr: string;
// See modifiers in https://regex.sorokin.engineer/regular_expressions/#modifiers
retn RegexSetModifiers(const modifiers: string);
fn RegexGetMatches(const input: string): specialize ArrayOf<string>;
fn RegexHasMatches(const input: string): bool;
fn RegexGetLastError: string;
fn RegexGetLastErrorID: int;
fn RegexGetLastCompileErrorPos: int;
fn RegexGetMatch(const idx: int = 0): string;
fn RegexGetExpr: string;
fn RegexVerifyExpr: bool;
retn RegexAppendExpr(const expr: string);

resourcestring
	REGEX_FAILED	  = '%s: regular expression failed: %s';
	REGEX_FAILED_LOC  = '%s: regular expression failed at index %d : %s';

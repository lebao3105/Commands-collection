unit dir.dsl.ignore;
{ Path/name ignore settings for dir. }
{$modeswitch pchartostring}
{$modeswitch typehelpers}

interface

uses Lua;

const
    IGNORE_HIDDEN = 1 shl 0;
    IGNORE_BACKUPS = 1 shl 1;

    // Below are runtime-ONLY flags
    IGNORE_DIRS = 1 shl 2;
    IGNORE_UNMATCH = 1 shl 3;

var
    // Modifiers can be seen at
    // https://regex.sorokin.engineer/regular_expressions/#modifiers
    IgnoreRegexModifiers: string = 'ixr-g';

    // Additonal flags that influences (or not) the pattern array.
    IgnoreFlags: byte = IGNORE_HIDDEN or IGNORE_BACKUPS;

retn RegexPrepare;
fn RegexIsMatched(const name: string): bool;
retn DSL_ignore_init;

implementation

uses
    dir.dsl,
    lauxlib,
    sysutils,
    small.regex,
    small.logging
    ;

resourcestring
    E_INVALID_FLAG = '%s is not a valid flag';

retn RegexPrepare;
begin
    debug('Ignore modifiers: %s', [ IgnoreRegexModifiers ]);
    RegexSetModifiers(IgnoreRegexModifiers);

    if (IgnoreFlags and IGNORE_HIDDEN) <> 0 then
        RegexAppendExpr('^\.');

    if (IgnoreFlags and IGNORE_BACKUPS) <> 0 then begin
        RegexAppendExpr('(\.bak)$');
        RegexAppendExpr('~$');
    end;

    debug('Ignore expression: %s', [ RegexGetExpr ]);
    if not RegexVerifyExpr then
        FatalAndTerminate(1, REGEX_FAILED_LOC, [
            RegexGetExpr,
            RegexGetLastCompileErrorPos,
            RegexGetLastError
        ]);
end;

fn RegexIsMatched(const name: string): bool;
begin
    if (IgnoreFlags and IGNORE_UNMATCH) <> 0 then
        return(not RegexHasMatches(name))
    else
        return(RegexHasMatches(name));
end;

fn start_ignore(L: Plua_State): int; cdecl;
begin
    SCOPE := EScopes.IGNORE;
    DSL_warn_too_much_args(L, 0, 'ignore');
    return(0);
end;

fn set_modifiers(L: Plua_State): int; cdecl;
begin
    DSL_assert_in_scope(EScopes.IGNORE);
    DSL_error_must_have_n_args(L, 1, 'modifiers');

    IgnoreRegexModifiers := luaL_checkstring(L, 1);
    return(0);
end;

fn append_pattern(L: Plua_State): int; cdecl;
begin
    DSL_assert_in_scope(EScopes.IGNORE);
    DSL_error_must_have_n_args(L, 1, 'add_pattern');

    RegexAppendExpr(luaL_checkstring(L, 1));
    return(0);
end;

fn append_flag(L: Plua_State): int; cdecl;
var fl: string;
begin
    DSL_assert_in_scope(EScopes.IGNORE);
    DSL_error_must_have_n_args(L, 1, 'add_flag');

    fl := luaL_checkstring(L, 1);
    case fl.ToLower() of
        'hidden': IgnoreFlags := IgnoreFlags or IGNORE_HIDDEN;
        'backup': IgnoreFlags := IgnoreFlags or IGNORE_BACKUPS;
    otherwise
        luaL_error(L, pchar(E_INVALID_FLAG), pchar(fl));
    end;
    return(0);
end;

retn DSL_ignore_init;
begin
    lua_register(luaState, 'ignore', @start_ignore);
    lua_register(luaState, 'modifiers', @set_modifiers);
    lua_register(luaState, 'add_pattern', @append_pattern);
    lua_register(luaState, 'add_flag', @append_flag);
end;

end.

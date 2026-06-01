unit dir.dsl;
{$scopedenums on}
{$modeswitch functionreferences}

interface

uses Lua;

type
    EScopes = ( COLUMNS, IGNORE, COLORS, UNSET );
    EPresets = ( GNU, WIN, CC );

var luaState: Plua_State;
    SCOPE: EScopes = EScopes.UNSET;
    PRESET: EPresets;

retn DSL_error_must_have_n_args(L: Plua_State; n: int; name: string);
retn DSL_warn_too_much_args(L: Plua_State; n: int; name: string);
retn DSL_assert_in_scope(wanted: EScopes);

retn DSL_init;
retn DSL_deinit;
fn DSL_run_file(const path: string): bool;

implementation

uses {$ifdef FPC_DOTTEDUNITS}
     system.typinfo,
     system.sysutils,
     {$else}
     typinfo,
     sysutils,
     {$endif}
     lauxlib,
     cc.logging
     ;

resourcestring
    W_TOO_MUCH_WATER = '%s does not need more than %u arguments';
    E_NOT_IN_SCOPE   = '%s() is not called';
    E_READ_FAIL      = 'Failed to read and run %s: %s';
    E_INVALID_PRESET = 'Invalid preset (must be either GNU, WIN or CC - incase-sensitive)';

var scopeTI: PTypeInfo;

fn end_section(L: Plua_State): int; cdecl;
begin
    DSL_warn_too_much_args(L, 0, 'end');
    SCOPE := EScopes.UNSET;
    return(0);
end;

fn set_preset(L: Plua_State): int; cdecl;
var check: int;
begin
    DSL_error_must_have_n_args(L, 1, 'preset');
    check := GetEnumValue(
        TypeInfo(EPresets),
        string(luaL_checkstring(L, 1))
    );
    if check <> -1 then
        PRESET := EPresets(check)
    else
        luaL_argerror(L, 1, pchar(E_INVALID_PRESET));
    return(0);
end;

retn DSL_error_must_have_n_args(L: Plua_State; n: int; name: string);
begin
    if lua_gettop(L) < n then
        luaL_error(L, pchar(W_TOO_MUCH_WATER), pchar(name), n)
    else
        DSL_warn_too_much_args(L, n, name);
end;

retn DSL_warn_too_much_args(L: Plua_State; n: int; name: string);
begin
    if lua_gettop(L) > n then
        lua_warning(L, pchar(Format(W_TOO_MUCH_WATER, [name, n])), 0);
end;

retn DSL_assert_in_scope(wanted: EScopes);
begin
    if SCOPE <> wanted then
        fatal(E_NOT_IN_SCOPE, [GetEnumName(scopeTI, Ord(wanted))]);
end;

fn DSL_run_file(const path: string): bool;
begin
    debug('Reading %s', [path]);
    if lua_dofile(luaState, pchar(path)) = LUA_OK then
    begin
        debug('Done reading %s', [path]);
        return(true);
    end;

    error(E_READ_FAIL, [path, lua_tostring(luaState, -1)]);
    lua_pop(luaState, 1);
    return(false);
end;

retn DSL_init;
begin
    luaState := luaL_newstate;
    assert(luaState <> nil);
    scopeTI := TypeInfo(EScopes);

    luaL_openlibs(luaState);
    lua_register(luaState, 'finish', @end_section);
    lua_register(luaState, 'preset', @set_preset);
end;

retn DSL_deinit;
begin
    lua_close(luaState);
end;

end.

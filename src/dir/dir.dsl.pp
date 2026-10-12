unit dir.dsl;
{$scopedenums on}
{$modeswitch functionreferences}

interface

uses Lua;

type
    EScopes = ( COLUMNS, IGNORE, COLORS, UNSET );
    EPresets = ( GNU, WIN, CC );

var
    SCOPE: EScopes = EScopes.UNSET;
    PRESET: EPresets;
    canRunDSL: bool = false;

procedure DSL_register(name: pansichar; f: lua_CFunction);
procedure DSL_error_must_have_n_args(L: Plua_State; n: sizeint; name: string);
procedure DSL_warn_too_much_args(L: Plua_State; n: sizeint; name: string);
procedure DSL_assert_in_scope(wanted: EScopes);

procedure DSL_run_file(const path: string);

implementation

uses typinfo,
     sysutils,
     lauxlib,
     dir.presets,
     small.logging
     ;

resourcestring
    W_TOO_MUCH_WATER  = '%s does not need more than %u arguments';
    E_NEED_MORE_POWER = '%s needs exactly %u arguments';
    E_NOT_IN_SCOPE    = '%s() is not called';
    E_READ_FAIL       = 'Failed to read and run %s: %s';

var scopeTI: PTypeInfo;
    luaState: Plua_State;

function end_section(L: Plua_State): int; cdecl;
begin
    DSL_warn_too_much_args(L, 0, 'finish');
    SCOPE := EScopes.UNSET;
    return(0);
end;

function set_preset(L: Plua_State): int; cdecl;
begin
    DSL_error_must_have_n_args(L, 1, 'preset');
    PresetFromString(string(luaL_checkstring(L, 1)));
    return(0);
end;

procedure DSL_register(name: pansichar; f: lua_CFunction);
begin
    DSL_register(name, f);
end;

procedure DSL_error_must_have_n_args(L: Plua_State; n: sizeint; name: string);
begin
    if lua_gettop(L) < n then
        luaL_error(L, pchar(E_NEED_MORE_POWER), pchar(name), n)
    else
        DSL_warn_too_much_args(L, n, name);
end;

procedure DSL_warn_too_much_args(L: Plua_State; n: sizeint; name: string);
begin
    if lua_gettop(L) > n then
        lua_warning(L, pchar(Format(W_TOO_MUCH_WATER, [name, n])), 0);
end;

procedure DSL_assert_in_scope(wanted: EScopes);
begin
    if SCOPE <> wanted then
        fatal(E_NOT_IN_SCOPE, [GetEnumName(scopeTI, Ord(wanted))]);
end;

procedure DSL_run_file(const path: string);
begin
    if not canRunDSL then
    begin
        debug('Not gonna run %s because the user has not requested it', [path]);
        return;
    end;

    debug('Reading %s', [path]);
    if lua_dofile(luaState, pchar(path)) <> LUA_OK then
    begin
        error(E_READ_FAIL, [path, lua_tostring(luaState, -1)]);
        lua_pop(luaState, 1);
    end;

    debug('Done reading %s', [path]);
end;

var setting_file: string;

initialization
    setting_file := GetEnvironmentVariable('DIR_CONF');
    if not FileExists(setting_file) then
    begin
        debug('DIR_CONF = %s does not exist, skipping and using defaults', [setting_file]);
        return;
    end;

    debug('DIR_CONF = ' + setting_file);

    luaState := luaL_newstate;
    assert(luaState <> nil);
    scopeTI := TypeInfo(EScopes);

    luaL_openlibs(luaState);
    DSL_register('finish', @end_section);
    DSL_register('preset', @set_preset);
    canRunDSL := true;
    // DIR libraries and settings file will be loaded later

finalization
    if (luaState <> nil) then
        lua_close(luaState);

end.

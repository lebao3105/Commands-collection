{$I lauxlib.inc}

implementation

procedure lua_pushstring(L: Plua_State; const s: ansistring);
begin
  lua_pushlstring(L, PAnsiChar(s), Length(s));
end;

procedure luaL_openselectedlibs(L: Plua_State; load, preload: int); cdecl; external;
procedure luaL_openlibs(L: Plua_State);
begin
    luaL_openselectedlibs(L, 0, 0);
end;

function luaL_checkboolean(L: Plua_State; index: Integer): boolean;
begin
    Result := lua_isboolean(L, index) and lua_toboolean(L, index);
end;

function lua_open: Plua_State;
begin
  Result := luaL_newstate;
end;

function luaL_typename(L: Plua_State; i: Integer): PAnsiChar;
begin
  Result := lua_typename(L, lua_type(L, i));
end;

function luaL_loadfilex(L: Plua_State; const filename, mode: PAnsiChar): Integer; cdecl; external;
function lua_dofile(L: Plua_State; const filename: PAnsiChar): Integer;
begin
  Result := luaL_loadfilex(L, filename, nil);
  if Result = 0 then
    Result := lua_pcall(L, 0, LUA_MULTRET, 0);
end;

procedure luaL_argcheck(L: Plua_State; cond: Boolean; numarg: Integer; extramsg: PAnsiChar);
begin
  if not cond then
    luaL_argerror(L, numarg, extramsg)
end;

function luaL_checkstring(L: Plua_State; n: Integer): PAnsiChar;
begin
  Result := luaL_checklstring(L, n, nil)
end;

function luaL_optstring(L: Plua_State; n: Integer; d: PAnsiChar): PAnsiChar;
begin
  Result := luaL_optlstring(L, n, d, nil)
end;

function luaL_checkint(L: Plua_State; n: Integer): Integer;
begin
  Result := Integer(Trunc(luaL_checknumber(L, n)))
end;

function luaL_checklong(L: Plua_State; n: Integer): LongInt;
begin
  Result := LongInt(Trunc(luaL_checknumber(L, n)))
end;

function luaL_optint(L: Plua_State; n: Integer; d: Double): Integer;
begin
  Result := Integer(Trunc(luaL_optnumber(L, n, d)))
end;

function luaL_optlong(L: Plua_State; n: Integer; d: Double): LongInt;
begin
  Result := LongInt(Trunc(luaL_optnumber(L, n, d)))
end;

end.

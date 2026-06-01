{$I lua.inc}

implementation

procedure lua_pop(L: Plua_State; n: Integer);
begin
    lua_settop(L, -n - 1);
end;

procedure lua_newtable(L: Plua_State);
begin
    lua_createtable(L, 0, 0);
end;

procedure lua_register(L: Plua_State; const n: PAnsiChar; f: lua_CFunction);
begin
    lua_pushcfunction(L, f);
    lua_setglobal(L, n);
end;

procedure lua_pushcfunction(L: Plua_State; f: lua_CFunction);
begin
    lua_pushcclosure(L, f, 0);
end;

function lua_strlen(L: Plua_State; i: Integer): size_t;
begin
    Result := lua_objlen(L, i);
end;

function lua_isfunction(L: Plua_State; n: Integer): Boolean;
begin
    Result := lua_type(L, n) = LUA_TFUNCTION;
end;

function lua_istable(L: Plua_State; n: Integer): Boolean;
begin
    Result := lua_type(L, n) = LUA_TTABLE;
end;

function lua_islightuserdata(L: Plua_State; n: Integer): Boolean;
begin
    Result := lua_type(L, n) = LUA_TLIGHTUSERDATA;
end;

function lua_isnil(L: Plua_State; n: Integer): Boolean;
begin
    Result := lua_type(L, n) = LUA_TNIL;
end;

function lua_isboolean(L: Plua_State; n: Integer): Boolean;
begin
    Result := lua_type(L, n) = LUA_TBOOLEAN;
end;

function lua_isthread(L: Plua_State; n: Integer): Boolean;
begin
    Result := lua_type(L, n) = LUA_TTHREAD;
end;

function lua_isnone(L: Plua_State; n: Integer): Boolean;
begin
    Result := lua_type(L, n) = LUA_TNONE;
end;

function lua_isnoneornil(L: Plua_State; n: Integer): Boolean;
begin
    Result := lua_type(L, n) <= 0;
end;

procedure lua_pushliteral(L: Plua_State; s: PAnsiChar);
begin
    lua_pushlstring(L, s, Length(s));
end;

function lua_tostring(L: Plua_State; i: Integer): PAnsiChar;
begin
    Result := lua_tolstring(L, i, nil);
end;

function lua_pcallk(L: Plua_State;
                    nargs, nresults, errf: Integer;
                    ctx: lua_KContext; k: lua_KFunction): Integer; cdecl; external;
function lua_pcall(L: Plua_State; nargs, nresults, errf: Integer): Integer;
begin
    Result := lua_pcallk(L, nargs, nresults, errf, 0, nil);
end;

function lua_objlen(L: Plua_State; idx: Integer): size_t;
begin
    Result := lua_rawlen(L, idx);
end;

(******************************************************************************
* Copyright (C) 1994-2003 Tecgraf, PUC-Rio.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
******************************************************************************)
end.

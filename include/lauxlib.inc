(******************************************************************************
 *                                                                            *
 *  File:        lauxlib.pas                                                  *
 *  Authors:     TeCGraf           (C headers + actual Lua libraries)         *
 *               Lavergne Thomas   (original translation to Pascal)           *
 *               Bram Kuijvenhoven (update to Lua 5.1.1 for FreePascal)       *
 *  Description: Lua auxiliary library                                        *
 *                                                                            *
 ******************************************************************************)

(*
** $Id: lauxlib.h,v 1.59 2003/03/18 12:25:32 roberto Exp $
** Auxiliary functions for building Lua libraries
** See Copyright Notice in lua.h
**
** Translated to pascal by Lavergne Thomas
** Notes :
**    - Pointers type was prefixed with 'P'
** Bug reports :
**    - thomas.lavergne@laposte.net
**   In french or in english
** Updated to Lua 5.5 by CC devs
*)

unit lauxlib;
{$modeswitch result}

interface

uses
  Lua;

// functions added for Pascal
procedure lua_pushstring(L: Plua_State; const s: ansistring);

type
  luaL_reg = record
    name: PAnsiChar;
    func: lua_CFunction;
  end;
  PluaL_reg = ^luaL_reg;

procedure luaL_openlibs(L: Plua_State);
function luaL_argerror(L: Plua_State; numarg: Integer; const extramsg: PAnsiChar): Integer; cdecl; external;
function luaL_checknumber(L: Plua_State; numArg: Integer): lua_Number; cdecl; external;
function luaL_optnumber(L: Plua_State; nArg: Integer; def: lua_Number): lua_Number; cdecl; external;
function luaL_checkinteger(L: Plua_State; numArg: Integer): lua_Integer; cdecl; external;
function luaL_optinteger(L: Plua_State; nArg: Integer; def: lua_Integer): lua_Integer; cdecl; external;
function luaL_checklstring(L: Plua_State; numArg: Integer; l_: Psize_t): PAnsiChar; cdecl; external;
function luaL_optlstring(L: Plua_State; numArg: Integer; const def: PAnsiChar; l_: Psize_t): PAnsiChar; cdecl; external;

procedure luaL_checkstack(L: Plua_State; sz: Integer; const msg: PAnsiChar); cdecl; external;
procedure luaL_checktype(L: Plua_State; narg, t: Integer); cdecl; external;
procedure luaL_checkany(L: Plua_State; narg: Integer); cdecl; external;

procedure luaL_where(L: Plua_State; lvl: Integer); cdecl; external;
function luaL_error(L: Plua_State; const fmt: PAnsiChar): Integer; cdecl; varargs; external;

function luaL_checkoption(L: Plua_State; narg: Integer; def: PAnsiChar; lst: PPAnsiChar): Integer; cdecl; external;

function luaL_newstate: Plua_State; cdecl; external;
function lua_open: Plua_State; // compatibility; moved from unit lua to lauxlib because it needs luaL_newstate

function luaL_gsub(L: Plua_State; const s, p, r: PAnsiChar): PAnsiChar; cdecl; external;

(*
** ===============================================================
** some useful macros
** ===============================================================
*)

procedure luaL_argcheck(L: Plua_State; cond: Boolean; numarg: Integer; extramsg: PAnsiChar);
function luaL_checkstring(L: Plua_State; n: Integer): PAnsiChar;
function luaL_optstring(L: Plua_State; n: Integer; d: PAnsiChar): PAnsiChar;
function luaL_checkint(L: Plua_State; n: Integer): Integer;
function luaL_checklong(L: Plua_State; n: Integer): LongInt;
function luaL_checkboolean(L: Plua_State; index: Integer): boolean;
function luaL_optint(L: Plua_State; n: Integer; d: Double): Integer;
function luaL_optlong(L: Plua_State; n: Integer; d: Double): LongInt;

function luaL_typename(L: Plua_State; i: Integer): PAnsiChar;

function lua_dofile(L: Plua_State; const filename: PAnsiChar): Integer;

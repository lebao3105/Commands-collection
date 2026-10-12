unit dir.dsl.cols;
// {$scopedenums on}
{$modeswitch pchartostring}
{$modeswitch implicitfunctionspecialization}

interface

uses Lua, small.fs, small.arr;

type
    EListingColumns = (
    	NAME, SIZE, KIND, PERMS, OWNER_NAME,
        OWNER_GROUP, LAST_MODIFIED, LAST_ACCESSED
    );

var
    ColumnsEnabled: bool = false;
    PrintHeaders: bool = false; // not implemented
    Columns: specialize TArray<EListingColumns>;
    SizeFormat: string = '0.00'; // used in all presets
    TimeFormat: string;
    TypeFormats: array[0..Ord(High(EFSEntityKind))] of string;

implementation

uses dir.dsl, lauxlib, sysutils;

function start_columns(L: Plua_State): int; cdecl;
begin
    SCOPE := EScopes.COLUMNS;

    DSL_warn_too_much_args(L, 1, 'columns');
    if lua_gettop(L) = 1 then
        ColumnsEnabled := luaL_checkboolean(L, 1);

    return(0);
end;

function set_print_headers(L: Plua_State): int; cdecl;
begin
    DSL_assert_in_scope(EScopes.COLUMNS);
    DSL_warn_too_much_args(L, 1, 'print_headers');

    if lua_gettop(L) = 0 then
        PrintHeaders := true
    else
        PrintHeaders := luaL_checkboolean(L, 1);

    return(0);
end;

{$define APPEND_COL_IMPL :=
begin
    DSL_assert_in_scope(EScopes.COLUMNS);
    DSL_warn_too_much_args(L, 0, TARGET_NAME);
    ArrayAppend(Columns, EListingColumns.TARGET);
    return(0);
end}

function append_name_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'name'}
{$define TARGET := NAME}
APPEND_COL_IMPL;

function append_size_col(L: Plua_State): int; cdecl;
begin
    DSL_assert_in_scope(EScopes.COLUMNS);
    DSL_warn_too_much_args(L, 1, 'size');

    if lua_gettop(L) = 1 then
        SizeFormat := luaL_checkstring(L, 1);

    ArrayAppend(Columns, EListingColumns.SIZE);
    return(0);
end;

function append_time_format_col(L: Plua_State): int; cdecl;
begin
    DSL_assert_in_scope(EScopes.COLUMNS);
    DSL_warn_too_much_args(L, 1, 'time_format');

    if lua_gettop(L) = 1 then
        SizeFormat := luaL_checkstring(L, 1)
    else if PRESET = EPresets.WIN then
        SizeFormat := 'yyyy/mm/dd hh:mm:nn AM/PM';
        // default format on Windows

    return(0);
end;

function append_kind_col(L: Plua_State): int; cdecl;
var i: size_t;
begin
    DSL_assert_in_scope(EScopes.COLUMNS);
    DSL_warn_too_much_args(L, Ord(High(EFSEntityKind)), 'kind');

    for i := 1 to lua_gettop(L) do begin
        if LowerCase(luaL_checkstring(L, i)) <> 'skip' then
            TypeFormats[i] := luaL_checkstring(L, i);
    end;

    ArrayAppend(Columns, EListingColumns.KIND);
    return(0);
end;

function append_perms_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'perms'}
{$define TARGET := PERMS}
APPEND_COL_IMPL;

function append_owner_name_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'owner_name'}
{$define TARGET := OWNER_NAME}
APPEND_COL_IMPL;

function append_owner_group_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'owner_group'}
{$define TARGET := OWNER_GROUP}
APPEND_COL_IMPL;

function append_last_modified_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'last_modified'}
{$define TARGET := LAST_MODIFIED}
APPEND_COL_IMPL;

function append_last_accessed_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'last_accessed'}
{$define TARGET := LAST_ACCESSED}
APPEND_COL_IMPL;

{$undef TARGET}
{$undef APPEND_COL_IMPL}

initialization

if canRunDSL then
begin
    DSL_register('columns', @start_columns);
    DSL_register('name', @append_name_col);
    DSL_register('size', @append_size_col);
    DSL_register('time_format', @append_time_format_col);
    DSL_register('kind', @append_kind_col);
    DSL_register('perms', @append_perms_col);
    DSL_register('owner_name', @append_owner_name_col);
    DSL_register('owner_group', @append_owner_group_col);
    DSL_register('last_modified', @append_last_modified_col);
    DSL_register('last_accessed', @append_last_accessed_col);
end;

end.

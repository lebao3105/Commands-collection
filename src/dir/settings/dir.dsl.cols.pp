unit dir.dsl.cols;
{$scopedenums on}
{$modeswitch pchartostring}
{$modeswitch implicitfunctionspecialization}

interface

uses Lua, cc.fs, cc.base;

type
    EListingColumns = (
    	NAME, SIZE, KIND, PERMS, OWNER_NAME,
        OWNER_GROUP, LAST_MODIFIED, LAST_ACCESSED
    );

var
    ColumnsEnabled: bool = false;
    PrintHeaders: bool = false;
    Columns: specialize ArrayOf<EListingColumns>;
    SizeFormat: string = '0.00';

    (* These ones are the same in GNU & CC presets.
       Will be changed later if the preset is Windows. *)
    TimeFormat: string = 'mmm d hh:nn';
    TypeFormats: array[0..Ord(High(EFSEntityKind))] of string = (
        '-', 'd', 'l', 'p', 's', 'b', 'c', 'D', '?'
    );

retn DSL_cols_init;

implementation

uses dir.dsl, lauxlib;

fn start_columns(L: Plua_State): int; cdecl;
begin
    SCOPE := EScopes.COLUMNS;

    DSL_warn_too_much_args(L, 1, 'columns');
    if lua_gettop(L) = 1 then
        ColumnsEnabled := luaL_checkboolean(L, 1);

    return(0);
end;

fn set_print_headers(L: Plua_State): int; cdecl;
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

fn append_name_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'name'}
{$define TARGET := NAME}
APPEND_COL_IMPL;

fn append_size_col(L: Plua_State): int; cdecl;
begin
    DSL_assert_in_scope(EScopes.COLUMNS);
    DSL_warn_too_much_args(L, 1, 'size');

    if lua_gettop(L) = 1 then
        SizeFormat := luaL_checkstring(L, 1);

    ArrayAppend(Columns, EListingColumns.SIZE);
    return(0);
end;

fn append_time_format_col(L: Plua_State): int; cdecl;
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

fn append_kind_col(L: Plua_State): int; cdecl;
var i: size_t;
begin
    DSL_assert_in_scope(EScopes.COLUMNS);

    if (lua_gettop(L) = 0) and (PRESET = EPresets.WIN) then
    begin
        TypeFormats[Ord(EFSEntityKind.NormalFile)] := '';
        TypeFormats[Ord(EFSEntityKind.Dir)] := '<Folder>';
        TypeFormats[Ord(EFSEntityKind.Pipe)] := '<Pipe>';
        TypeFormats[Ord(EFSEntityKind.Socket)] := '<Socket>';
        TypeFormats[Ord(EFSEntityKind.Block)] := '<Block>';
        TypeFormats[Ord(EFSEntityKind.CharDev)] := '<Device>';
        TypeFormats[Ord(EFSEntityKind.Door)] := '<Door>';
        TypeFormats[Ord(EFSEntityKind.StatFailure)] := '<?????>';
    end
    else begin
        DSL_warn_too_much_args(L, Ord(High(EFSEntityKind)), 'kind');

        for i := 1 to lua_gettop(L) do begin
            if StrLowerCase(luaL_checkstring(L, i)) <> 'nan' then
                TypeFormats[i] := luaL_checkstring(L, i);
        end;
    end;

    ArrayAppend(Columns, EListingColumns.KIND);
    return(0);
end;

fn append_perms_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'perms'}
{$define TARGET := PERMS}
APPEND_COL_IMPL;

fn append_owner_name_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'owner_name'}
{$define TARGET := OWNER_NAME}
APPEND_COL_IMPL;

fn append_owner_group_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'owner_group'}
{$define TARGET := OWNER_GROUP}
APPEND_COL_IMPL;

fn append_last_modified_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'last_modified'}
{$define TARGET := LAST_MODIFIED}
APPEND_COL_IMPL;

fn append_last_accessed_col(L: Plua_State): int; cdecl;
{$define TARGET_NAME := 'last_accessed'}
{$define TARGET := LAST_ACCESSED}
APPEND_COL_IMPL;

{$undef TARGET}
{$undef APPEND_COL_IMPL}

retn DSL_cols_init;
begin
    lua_register(luaState, 'columns', @start_columns);
    lua_register(luaState, 'name', @append_name_col);
    lua_register(luaState, 'size', @append_size_col);
    lua_register(luaState, 'time_format', @append_time_format_col);
    lua_register(luaState, 'kind', @append_kind_col);
    lua_register(luaState, 'perms', @append_perms_col);
    lua_register(luaState, 'owner_name', @append_owner_name_col);
    lua_register(luaState, 'owner_group', @append_owner_group_col);
    lua_register(luaState, 'last_modified', @append_last_modified_col);
    lua_register(luaState, 'last_accessed', @append_last_accessed_col);
end;

end.

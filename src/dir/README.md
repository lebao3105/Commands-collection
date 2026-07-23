## dir settings

This feature is implemented by:

* Presets (set by `DIR_PRESET` environment variable on dir startup)
* Domain-specific language, which is Lua in disguise. Implemented by `dir.dsl*` units. Read from file specified by `DIR_CONF` environment variable.
    * `.cols` unit handles column settings
    * `.ignore` unit handles ignore (by name etc) settings
    * `.colors` unit handles color settings
    * `dir.dsl` itself not only handles DSL (de)initialization tasks but also top-level functions:
        - Presets
        - Errors and warnings
        - (TODO)...

## How the DSL works

### Sections

Each DSL unit has its own section, for example with column settings:

```lua
columns(true) -- start of a section
    -- do whatever you want
finish -- end, optional
```

Section start and end markers are actually Lua functions, which modifies a Pascal variable named *SCOPE* under the hood:

```pascal
type
    EScopes = ( COLUMNS, IGNORE, COLORS, UNSET );

var SCOPE: EScopes = UNSET;

// implements columns()
function start_columns_section(L: PLua_State): int; cdecl;
begin
    SCOPE := COLUMNS;
    // does additonal jobs if any...
    return(0); // no return value
end;

// implements finish()
function end_section(L: PLua_State): int; cdecl;
begin
    SCOPE := UNSET;
    return(0); // no return value
end;
```

*finish()* is not required, as section starters will override *SCOPE* anyways - no *SCOPE* check is required.

Of course, a function can check the current section it's in:

```pascal
// implements name(), which belongs to columns section
function append_name_column(L: PLua_State): int; cdecl;
begin
    // if SCOPE is not EScopes.COLUMNS,
    // throw an error. This however does not halt dir.
    DSL_assert_in_scope(EScopes.COLUMNS);
    // do what name() does
end;
```

### Functions

Functions, or settings if you want, known in dir's Lua files, are all implemented in Pascal with the following signature:

```pascal
function [name] (L: PLua_State) : integer; cdecl;
```

`[name]` is lower-cased.

This is the signature of Lua's `lua_CFunction` type. That `cdecl` part is **required**.

They are not visible outside their corresponding unit's `implementation`.

#### Implementation

1. You'll want to check the current section the function's called in;) (unless the function is the section starter)
2. Get number of arguments using `lua_gettop(L)`.
3. Get arugments casted to their corresponding type using `luaL_check*(L, argument index)`. Requires the import of `lauxlib` unit.
4. Always return 0 (no return value) until further...notice?
5. Nothing else.

#### Registeration (to Lua)

Use `lua_register(PLua_State, name, func)` in `DSL_*_init`.

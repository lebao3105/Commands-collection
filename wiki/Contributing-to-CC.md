> Note: This is written for developers and maintainers only!

# C, C++, C# keyword/features to Pascal

1. `{` and `}` => `begin` and `end`. `{` and `}` are used for comments and compiler directives.
2. `#define` => `{$define}` (no function-like macros allowed). The same goes to `#if defined`, `#else`, `#endif` and more
3. `void name(args)` => `procedure name(args);`
4. `<type> name(args)` => `function name(args): <type>;`
5. `enum class` => normal enum (before that use `{$scopedenums on}`, read the section below)
6. In Pascal: No `;` right before `else`
7. `switch(...) - case(val)` => `case(...) of - val:`. No `break` is required. Works with strings.
8. `extern "C"` before identifier => `external <optional libname> name <name of identifier in C>` after the identifier
9. `#include NAME` => `{$include NAME}` or `{$I NAME}` (a case of 2)
10. C++/C# lambda function => Pascal function/procedure with no name (read the section below)
11. C++/C# template => Pascal's [generic](https://wiki.freepascal.org/Generics)
12. Pascal strings can be concatenate together using + operator
13. Classes are NOT directly used unless it's neccessary.
14. `struct` => `record` Records with functions are doable using `{$modeswitch advancedrecords}`
15. `main()` function => single `begin-end.` (notice the dot) block.
16. Quit functions/scopes using `exit(whatever or not)` or `return` (alias of `exit`). Halt the program *anywhere* using `halt(exit code)`
17. `argc`, `argv` in `main()` are still accessible as int and PPChar (or `char**` in C). However we all use `ParamCount` (argc) and `ParamStr(index)` function (which returns a Pascal string)
18. Varadic parameters: use `array of const`:
```pascal
{$mode objfpc}

uses sysutils; // Format

procedure SayHello(names: array of const);
begin
    writeln(Format('Hello %s from %s!', names));
end;

begin
    SayHello( [ // <- Notice this
        'YOU', 'ME'
    ] );
end.
```

For external C functions, check [this](https://www.freepascal.org/docs-html/ref/refsu97.html).
19. Letter-case is ignored in Pascal. Applies for everything.

There are more of Pascal you should know. Check out[this](https://en.wikipedia.org/wiki/Pascal_(programming_language)#Language_constructs) and Free Pascal [wiki](https://wiki.freepascal.org).

# Project structure

```bash
$ tree ..
|   build-aux/      # Build helper scripts
|   changelogs/     # Self-explanatory
|   docs/           # Documents + related scripts
|   i18n/           # Localizations for shared units
|   include/        # Shared unit header files(*)
|   src/
|       dir/...     # Programs
|       shared/     # Shared units
|   cc.cfg          # Compiler flags
|   crowdin.yml     # Crowdin (translation service) settings
|   options.lua     # Build options
|   xmake.lua       # Main build file
```

\*: They do the same work as C/C++ header files.

# Used Pascal/FPC features

## Anonymous functions/procedures

> Note: This is available in FPC trunk.

Requires these modeswitches:

* `{$modeswitch anonymousfunctions}` for the feature itself;
* `{$modeswitch result}` for anonymous **functions** (you know that they're different than procedures)

Usages can be found across the project.

Remember to check for the anonmymous function's signature, because you can encounter this:

```
cc.getopts.pp:363:12: error: (4025) Incompatible type for arg no. 2:
Got "anonymous function(const SmallInt;const ShortString):System.Boolean;", expected "FARRAYFOREACHINDEXCALLBACK<System.ShortString>"
```

Occured because of a *const* modifier.

## Implicit generic specialization

> Note: This is available in FPC trunk.
> This only applies to generic functions/procedures.

Modeswitch: `{$modeswitch implicitfunctionspecialization}`

Pseudo code:

```pascal
generic procedure aProc<T>(param1, param2, ...: T);

specialize aProc<int>(number1, number2, ...);

aProc(param1, param2, ...); // works
```

This, however has at least one downside:
* Different types that are aliases to a specific type (e.g CC's `ArrayOf<string>` and RTL's `TStringDynArray`) will not work.
* It's still best to not totally remove `specialize`, for the sake of code-understanding and maybe debugging.

## (DO NOT USE) Unicode RTL

> Note: FPC, of course, welcomes contributions.

Unicode RTL exists and is usable, however not in CC. Problems exist in both compile and run time:

* `resourcestring`s cause conversion errors;
* garbage data sometimes.
* a bunch of conversion warnings.

## Dotted units

Or rather say, namespaced units.

> Support for this thing will be removed in the next version of CC (releases in this June?) as:
> 1. Not enabled by default in FPC+RTL builds.
> 2. Not supported in FPCUpdeluxe (our beloved FPC installer)
> 3. Takes spaces, and a bit of time just to get/remember the right unit name
> 4. Who actually use it?
> 5. No benefits (CC shared units have cc. prefix)

Dotted unit names:
* RTL: `system.` + names found in non-dotted
* UNIX-only: `unixapi.` + slightly changed name (e.g `baseunix` => `unixapi.base`)
* Windows-only: `winapi.` + slightly changed name

Correct names can be found in `namespaced` folders found across the FPC source code.

`FPC_DOTTEDUNITS` symbol is also defined for easy `uses` choice:

```pascal
uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils, system.strutils,
    {$else}
    sysutils, strutils,
    {$endif}
```

If you want to have one, run these in FPC source code:

```bash
$ make -C rtl      FPC_DOTTEDUNITS=1 clean all
$ make -C packages FPC_DOTTEDUNITS=1 clean all
$ make -C rtl      FPC_DOTTEDUNITS=1 install
$ make -C packages FPC_DOTTEDUNITS=1 install
```

Note that the compiler does NOT use dotted units.

## Scoped enums

By default, values inside an enum are visible globally:

```pascal
type
    EEnum = (FLAG, FLAG_TWO);

var t: EEnum = FLAG;
```

It's not recommended to do that, as it can cause ambiguities. That's why `{$scopedenums on}` is used:

```pascal
{$scopedenums on}
type
    EEnum = (FLAG, FLAG_TWO);

var t: EEnum = FLAG; // Error
    j: EEnum = EEnum.FLAG_TWO; // Ok
```

Scoped enums works the same way as `enum class` in C++.

## Some other known `modeswitch`es

* `advancedrecords`: Records with methods
* `defaultparameters`: Default parameter values for procedures / functions
* `out`: `out` parameters in procedures / functions

## Aliases

All are created via compiler definitions (`-d` flag) and is used widely.

See the project's `cc.cfg`.

## Include files

Pascal by default requires declaration and implementation of everything to be put in one file.

This makes the file big and time-consuming to read and navigate.

CC recommends you to split the code into include files and a main file for each part of the project, as seen in C and C++ projects.

All files to be included must have `.inc` extension. They can be included using `{$I}` or `{$INCLUDE}` directive.

# Creating a new program

Create a new folder in [src/](../src/) that is named after the program.

Its folder structure is as follow:
```bash
$ tree src/hello
|       config.inc # Store configurations, e.g command-line flags
|       i18n.inc   # Localizable strings
|       hello-world.pp # Main program file
|       ...        # Whatever
|       i18n/      # Template + localized strings
```

For *config.inc* and *i18n.inc*, read [this](../src/shared/argpas/README.md).

For how to parse arguments, read that document too, and existing CC programs (recommendation: `hello`).

# Documentation

CC can now generate HTMLs for APIs.

Knowing that you have cloned the repository with submodules cloned, run:

```bash
$ xmake b API-docs
```

This will generate HTMLs in `docs/api`.

`scdoc` is used. Each program have their own `-docs` target.

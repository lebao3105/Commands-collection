# Contributing to CommandsCollection

## Setup

* Latest stable FPC (Free Pascal Compiler)
* Make

## Building (and generating `Makefile`)

FPCMake can be used:

```bash
$ fpcmake -w -Tall
<bunch of target requirement(s) and such>
Writing Makefile
```

To compile a/any program, do:

```bash
$ make src/<program name>
```

Append `.exe` if you're on Windows (optional).

To build everything:

```bash
$ make
```

To clean everything:

```bash
$ make clean
```

All targets are shown [here](https://www.freepascal.org/docs-html/prog/progse81.html#x296-312000E.2), although NOT all are meant to be used.

Also variables set by `fpcmake` [here](https://www.freepascal.org/docs-html/prog/progse86.html#x313-329000E.7).

There are still some more to use:

* `DEBUG` and `RELEASE` = build variants
* `CREATESMART` = create smartlinked library
* `LINKSMART` = smart linking
* `STRIP` = symbol and stuff stripping
* `VERBOSE` = a little bit more verbose'ing compile output
* `OPTIMIZE` = optimized output (level 2 according to 3.2.2 fpcmake)

## Code style

### Type definition

They are named using PascalCase convention.

* Records: start with `R` (e.g `RCmdFlag`);
* Classes, `object`s etc: start with `T` (e.g `TDirApp`);
* Pointer (^`TType`): start with `P` (e.g `PEntry = ^TEntry`).

### Variable definition

Should be sorted alphabetically + by length.

Named using either PascalCase or camelCase convention.

## Definitions

They are definied in [Makefile.fpc](Makefile.fpc):

* `bg` = `begin`. Do NOT use it in `program`'s main block;
* `ed` = `end`. Do NOT use it in `program`'s main block;
* `retn` = `produce`;
* `fn` = `function`;
* `ctor` = `constructor`;
* `dtor` = `destructor`.

Some more might be defined depending on the target OS + other compile flags.

## Type aliases

They do not appear as macros. Placed in [include/base.pp](include/base.pp).

## Additional informations

* `-Sx` is used for Exception keywords (`try`, `except`, `finally`, `raise`);
* `-Sa` is used for assertions;
* `-Sm` is used for macros;
* `-Sc` is used for C operators;
* `-Si` is used for inline functions.
* Anonymous function (or lambda function) is available on **in-development** FPC;
* One should list used stuff from an unit in the `uses` section;
* "Long" strings (aka `ansistring` or `string` with `{$longstrings on}` or `{$h+}`) are usually used.

## Create a new program

Create a new file in `src`. Some units to include (not required to add all of them):

* `base`: Type aliases;
* `console`: Print colored text and more;
* `custcustapp` (to be renamed): Argument parser;
* `logging`: Self-explantory;
* `sysinf`: System informations;
* `utils`: Uncategorized utilities.

If you decide to use `custcustapp`, create 2 functions:

* One for extra help messages (optional) - returning a string;
* One for handle read flag (required) - has one `char` parameter(\*).

\* Inside the handler, use a `case` check against the option's **short** name.

In the main block:

* Assign `MoreHelpFunction` with the address of the created help message;
* Assign `OptionHandler` with the address of the created handler.
* Add options via `custcustapp.AddOption`;
* Start using `custcustapp.Start`;
* Continue the program routine: handle flags, options etc set by the handler.

Non options (ones that do not belong to any option) can be retrieved by `GetNonOptions`.
They only available after parsing.

Errors while parsing can be skipped by setting `custcustapp.IgnoreErrors` to true.

### How about repeatable options?

Create an array of string, and append the assigned value (`getopts.OptArg`) to that array.

[`env`](src/env.pp) is an example.

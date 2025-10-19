# Contributing to CommandsCollection

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

> Note: these are not APPLIED to fpmake.pp!

They are definied in [fpmake.pp](build-aux/fpmake.pp):

* `bg` = `begin`. Do NOT use it in `program`'s main block;
* `ed` = `end`. Do NOT use it in `program`'s main block;
* `retn` = `produce`;
* `fn` = `function`;
* `return` = `exit`;
* and maybe more - check the file.

## Type aliases

> Note: these are not APPLIED to fpmake.pp!

They are defined globally:

* `long` = `longint`;
* `ulong` = `longword`;
* `bool` = `boolean`;
* `int` = `integer`.

## Additional information

> Note: some are not APPLIED to fpmake.pp!

* `-Sx` is used for Exception keywords (`try`, `except`, `finally`, `raise`);
* `-Sa` is used for assertions;
* `-Sm` is used for macros;
* `-Sc` is used for C operators;
* `-Si` is used for inline functions.
* Anonymous function (or lambda function) is available on **in-development** FPC;
* One should list used stuff from an unit in the `uses` section;
* "Long" strings (aka `ansistring` or `string` with `{$longstrings on}` or `{$h+}`) are usually used.

## Create a new program

### Write a new file

Create a new file with the `.pp` extension in [src](src). Some units to [include](include) (not required to add all of them) and update (if you want and the thing to add is fit):

* `base`: Type aliases blah blah;
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

#### How about repeatable options?

Create an array of string, and append the assigned value (`getopts.OptArg`) to that array.

[`env`](src/env.pp) is an example.

#### Is is required to write some addtional messages?

No:v "additional messages" already answered that.

You do not need to write a function and assign `MoreHelpFunction` with its address, at all.

### Tell fpmake the program's exisitence

Edit [Targets.json](build-aux/Targets.json).
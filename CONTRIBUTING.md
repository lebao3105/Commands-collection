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

> Note: Parts of this section are outdated due to the use of C GetOpt. Will update later.
> For now, check programs like calltime and dir for examples.

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

Non options (ones that do not belong to any option) can be retrieved by `custcustapp.NonOptions`.
Only use that after parsing.

Errors while parsing can be skipped by setting `custcustapp.IgnoreErrors` to true.

#### How about repeatable options?

Create an array of string, and append the assigned value (`getopts.OptArg`) to that array.

[`env`](src/env.pp) is an example.

#### Is is required to write some addtional messages?

No:v "additional messages" already answered that.

You do not need to write a function and assign `MoreHelpFunction` with its address, at all.

### Tell fpmake the program's exisitence

Edit [Targets.json](build-aux/Targets.json).

## FAQ

### Does Free Pascal have `constexpr`?

Yes, according to its [wiki](https://wiki.freepascal.org/Const):

> The declaration const in a Pascal program is used to inform the compiler that certain identifiers which are being declared are constants, that is, they are **initialized with a specific value at compile time** as opposed to a variable which is initialized at run time.

Just use the `const` keyword as usual.

Also one thing: constants are...re-assignable by DEFAULT. While nobody would read a `const` and try to reassign it, to totally avoid that case, use `{$J-}` or `{$WriteableConst OFF}`.

## How do I call C stuff from Pascal?

Include `ctypes` unit.

Here are some quick convertions:
* C int => ctypes's cint(32) = Pascal's longint;
* C char => ctypes's cchar;
* C string (pointer of char) => Pascal's pchar;
* C bool => ctypes's cbool => Pascal's longbool;
* C struct => make the same one in Pascal. Don't forget to `packed` it if needed.

As always, it's good to check [this](https://www.freepascal.org/docs-html/rtl/ctypes/index-3.html).

Declare your whatever as usual. Append `extern`, following by a **library** name, e.g 'c' for libC. Add `name` modifier (next to the library name) if you want to change the name of your thing in Pascal.

Samples can be seen in `custcustapp`.

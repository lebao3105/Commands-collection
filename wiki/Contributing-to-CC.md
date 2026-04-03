# Considerations?

## CRNL

As CC modifies some console attributes (both stdout, stderr and sometimes stdin are modified), the output may look (un)funny like this:

```bash
$ xmake b -r inp && xmake r inp --help
[ 31%]: linking.debug inp
[100%]: build ok, spent 0.767s
debug: Initializing console module...
Asks for user input.
                    --message  -m  VALUE
                                        	Custom message to show instead of Press any key/Enter to continue
                                                                                                                 --hide-input  -t
                                                                                                                                 	Hide inputs from the user
                     --require-enter  -e
                                        	Require Enter to send the input
                                                                               --require-chars  -k  VALUE
                                                                                                         	Specify valid characters
                                                                                                                                        --loop  -l
      	Do not quit until a valid input is sent
                                               --show-availables  -o
                                                                    	Show the user -k value
                                                                        ...
```

This is due to usage of RTL-console functions that modify the console under-the-hood. One common thing is the RAW mode.

That's why I decided to not use RTL's `crt` at the first place, thinking it did something to break the output. Now I understand why :wilted_rose: - sorry dude.

One possible fix is to use `SetTextLineEnding` on stdout and stderr (should we use this on stdin?) so that writeln can still work as usual. This, however, does not apply to RTL's `LineEnding` - which in some OSes a literal NL - as it's a **const**ant string.

But I do have a workaround as well. `CRNL` has been defined, globally. And as the name suggests,
it's Carriage return+New line!

# Pascal-only

## Dotted units

Or rather say, namespaced units.

Typically, FPC's dotted RTL (and included packages) have `System.` (notice the dot) prefix in their name.

Not all units have `system.` name prefix. For instance, UNIX-only units are prefixed with `unixapi.` instead.

`FPC_DOTTEDUNITS` symbol is also defined for easy `uses` choice:

```pascal
uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils, system.strutils,
    {$else}
    sysutils, strutils,
    {$endif}
```

This feature is disabled by default. Besides, not everyone use it (if not there are nobody) :D

(Wait, why do I add support for this thing?)

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

## Some known `modeswitch`es

* `advancedrecords`: Records with methods
* `result`: `Result` variable in functions
* `defaultparameters`: Default parameter values for procedures / functions
* `class`: Class keyword
* `out`: `out` parameters in procedures / functions

## Aliases

All are created via compiler definitions (`-d` flag) and is used widely.

See the project's `fpc.cfg`.

## Include files

Pascal allows declaration and implementation of a record, a class, a procedure a function, and more - in one file, separated to sections (`interface` - `implementation` in units) or not (`program` files).

As a result, the file can be very big in size and number of lines, taking more time to scroll through.

CC recommends you to split the code into include files and a main file for each part of the project.

All files to be included must have `.inc` extension. They can be included using `{$I}` or `{$INCLUDE}` directive.

## Definitions and C interop

Check [this one](https://github.com/lebao3105/Commands-collection/wiki/Macros,-aliases-and-C-interop-for-Pascal).

## Creating a new program

Create a new folder in [src/](../src/) that is named after the program.

Its folder structure is as follow:
```bash
$ tree src/hello-world
|       config.inc # Store configurations, e.g command-line flags
|       i18n.inc   # Localizable strings
|       hello-world.pp # Main program file
|       ...        # Whatever
```

`config.inc` must contain these stuff:

* `ARGA`: an array of command-line flags. It must end with `ARGA_SUFFIX`.
* `ARGA_SHORTOPTS`: a string that presents available command-line flags (in short form). If a flag can/need to have a value, give it a `:` behind the short character. For example:
    --message -m [MESSAGE] => `m:` in `ARGA_SHORTOPTS`

`ARGA_VERBOSE` can be used in `ARGA` to add verbosity.

Strings in `i18n.inc` must be put in `resourcestring` section, and `NEED_PROGRAM_HELP` check must be used for strings that will be used by `config.inc`.
Some more needed strings:
- `PROGRAM_DESC`: Program description;
- `PROGRAM_BONUS_HELP` (optional): Extra help messages - define `HAS_BONUS_HELP` if you use this

# Documentation

Made possible in feat/deC branch, CC can now generate HTMLs for APIs.

Knowing that you have cloned the repository with submodules cloned, run:

```bash
$ xmake b API-docs
```

This will generate HTMLs in `docs/api`.

`scdoc` is used. Each program have their own `-docs` target.

# Translations

> Note: Once again, this is implemented in the feat/deC branch.

## In Pascal

In Pascal, strings are put into `resourcestring`, which will be later put into a `.rsj` file.

That's it. XMake, GNU msgfmt and such tools will handle the rest.

Related tasks can be seen via `xmake -h`.

## For translators

Translate `.po` (NOT `.pot`!) files in i18n/.


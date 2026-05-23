> Note: This is written for developers and maintainers only!

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

Unicode RTL exists and is usable, however not in CC. While minimal support for it is here, problems exist in both compile and run time:

* `resourcestring`s cause conversion errors;
* garbage strings sometimes.
* a bunch of conversion warnings.

# Pascal-only

## Dotted units

Or rather say, namespaced units.

Typically, FPC's dotted RTL (and included packages) have `System.` (notice the dot) prefix in their name. UNIX-only units are prefixed with `unixapi.`, while Windows ones have `winapi.` prefix.

Namespaced names can be found in FPC package's `namespaced` folder.

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

## Some other known `modeswitch`es

* `advancedrecords`: Records with methods
* `defaultparameters`: Default parameter values for procedures / functions
* `class`: Class keyword
* `out`: `out` parameters in procedures / functions

## Aliases

All are created via compiler definitions (`-d` flag) and is used widely.

See the project's `cc.cfg`.

## Include files

Pascal by default requires declaration and implementation of everything to be put in one file.

This makes the file big and time-consuming to read and navigate.

CC recommends you to split the code into include files and a main file for each part of the project, as seen in C and C++ projects.

All files to be included must have `.inc` extension. They can be included using `{$I}` or `{$INCLUDE}` directive.

## Creating a new program

Create a new folder in [src/](../src/) that is named after the program.

Its folder structure is as follow:
```bash
$ tree src/hello-world
|       config.inc # Store configurations, e.g command-line flags
|       i18n.inc   # Localizable strings
|       hello-world.pp # Main program file
|       ...        # Whatever
|       i18n/      # Template + localized strings
```

For *config.inc* and *i18n.inc*, read [this](src/shared/argpas/README.md).

For how to parse arguments, read that document too, and existing CC programs (recommendation: calltime).

# Documentation

CC can now generate HTMLs for APIs.

Knowing that you have cloned the repository with submodules cloned, run:

```bash
$ xmake b API-docs
```

This will generate HTMLs in `docs/api`.

`scdoc` is used. Each program have their own `-docs` target.

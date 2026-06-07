# Argument parser for CC

This document contains technical details of `cc.getopts`, used for building applications.

## Required and not required stuff (application-specific)

### In program's config.inc

* `ARGA` (required): array of `TOption`. No runtime nor compile-time modifications.
    - Must end with `ARGA_SUFFIX`
        - Contains an empty TOption
        - Contains a TOption for printing out project version (-V / --version)
        - Contains, of course, --help and its short -h.
    - `ARGA_VERBOSE` can be added for verbosity (-v / --verbose)
    - `ARGA_USE_PAIRS` can be added for argument pairs
        - `PAIR_NUM` must be defined to a number >= 2
        - `ALLOW_PAIRS` must be defined
* `ALLOW_DOUBLE_SPECIFIER` (not required): Allow use of -- flag. Is a compiler definition.
    - When this is encountered (in runtime), getopts will consider everything after the flag non-options, immediately ending the parse.
    - -- is undocumented. Consider adding a small note yourself.

### In programs's i18n.inc

* Resource strings (in Pascal's **resourcestring** section)
    - Ones for the application's normal routine;
    - And ones for the options in **ARGA** above.
* `PROGRAM_BONUS_HELP` (as a resource string, not required): Bonus help message
    - `HAS_BONUS_HELP` must be defined

All strings are accessible from `i18n` unit.

## Argument pairs

Pairs is one of the most unique feature that CC offers. Let's advertise this a little bit.

Considering this argv:

```
rename --use-pairs    bye  hello \
       --interactive  home world \
       --uniform-ext  .txt
```

Pairs are:

* `bye` and `hello`;
* `home` and `world`;

`.txt` is `--uniform-ext`'s value, and if not, it's not enough for another pair.

A pair can consists of 2, 3 or even more values, depending on the purpose of the program.

## Notes

1. Combined short flags like -va are not allowed. Use -v -a instead.
2. In case of errors occured by invalid use of options, only the help of that option will be printed instead of the full program help. One condition is that the option must exist in ARGA.
3. Long-only options are supported
4. `NO_PROG` is used for i18n.
5. This unit is meant to be used to parse command line arguments *only once*.

## Internal implementation

### Conditions to end the parse

The parse will end if one of the conditions below is satisfied first:

1. `--` encountered while `ALLOW_DOUBLE_SPECIFIER` is defined
2. End of the argument vector reached. What? You think otherwise?
3. An error occured (invalid flag name etc)
4. Empty argument list. At the point the parse won't even start

### How it works

ArgPas gets the job done by traversing each command line argument.

With each argument:
0. Check if argument is `--` and `ALLOW_DOUBLE_SPECIFIER` is defined.
1. Check if there is a previous argument, and if it needs a value, this argument is the value it needs.
   Set `OptArg` to this argument and go read the next argument.
2. If (1) is not the case, check if the argument has `-` or `--` prefix. If yes, proceed to the next step.
   Otherwise append this argument to `NonOptions` and go read the next one.
3. Get the name+value of the flag:
    - If it's a short flag (`-` prefix): the flag name is the **second** character
    - Otherwise, the flag name is what between `--` and `=` (if any).
        - If the equal sign is present, we can get the flag's value right next to it.
        - If the flag is short, the flag value is everything after the first 2 characters.
        - If not, set an internal value and proceed.
4. Read ARGA for one that matches the flag. Throws error when:
    - No such flag found in ARGA
    - There is value for a flag that does not need one
5. Go to the next argument

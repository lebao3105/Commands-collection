# Argument parser for CC

This document contains technical details of `cc.getopts`, used for building applications.

## (Not) Required stuff (application-specific)

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
5. *GetOpt* function is supposed to run only **once**.

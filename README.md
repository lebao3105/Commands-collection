# Commands-collection

Build status:
[![Nightly CI](https://github.com/lebao3105/Commands-collection/actions/workflows/nightly.yml/badge.svg)](https://github.com/lebao3105/Commands-collection/actions/workflows/nightly.yml)

A collection of system commands written in Free Pascal.

They are:

* `calltime` = time & date getter
* `cat`
* `chk_type` = file / folder information getter
* `dir`
* `env`
* `inp` = asks for an input (e.g Press Enter to continue)
* `mkdir` + `touch` + `rm`
* `rename` = file / folder renamer
* `uname`
* `uptime`
* Overall: cross-platform programs that are seen in daily computer life
* Overall: proof-of-concept (POC)s

They are NOT:

* Copycats (although some are intended to behave like ones in GNU coreutils)
* Made to be laughed at
* Suitable for daily-use
* Fully optimized (atm)
* Object-oriented (although `TStringList` is used sometimes)
* Battle-tested

## Building

### Setup

* FPC (Free Pascal Compiler) 3.x with some packages(\*):
    * `users` and `regexpr` for `dir`;
    * `fcl-process` for `env`;
    * `fcl-process`, `fcl-json` and `fcl-jsonschema` for `fpmake`
* Git, to show the repository's revision in program's `-V`

\*: Technically you don't need to care about this. Default installations of FPC include them all.
Some Linux distributions like Debian separate packages into categories for easier management.
The RTL (Run Time Library) is always included as the very critical dependency of the program.

### Build

Compile [fpmake.pp](fpmake.pp) first:
```bash
    fpc -gl fpmake.pp
```

To build program(s) and/or unit(s):

```bash
    ./fpmake build --CompileTarget=<what to build, separated by commas>
    # to build everything
    ./fpmake build
    # if you love verbosity:
    ./fpmake build -v --CompileTarget=all
```

To clean:

```bash
    ./fpmake clean
```

To install:

```bash
    ./fpmake install -B <install path>
```

`--CompileTarget` is optional. Not providing it means you want fpmake to include all packages at once.

[CompileOptionsSchema.json](CompileOptionsSchema.json) can be used to create a CompileOptions.json, which will be used to manipulate some aspects of compilation.

`DEBUG` environment variable can be set to `1` to enable debug builds.

> Note: If you use FPC 3.2.2 and older, download and unpack this file:
> https://gitlab.com/freepascal.org/fpc/source/-/archive/main/source-main.tar?ref_type=heads&path=packages/fcl-jsonschema
> Add -sp <path to unpacked file> to fpmake's compilation (first command)

## Run

All programs are set to be placed in `build/bin/<target cpu+os>`.

The universal usage documentation is [here](USAGE.md).

## Credits

* [@ikelaiah](https://github.com/ikelaiah) for cli-fp library. Part of it is used and modified.

## References

* Linux man pages
* GNU Coreutils [source code](https://github.com/coreutils/coreutils)
* Free Pascal's Run time [library](https://www.freepascal.org/docs-html/rtl/index.html) (RTL)
* Procps-ng [source code](https://gitlab.com/procps-ng/procps)
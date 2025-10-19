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

* FPC (Free Pascal Compiler) 3.x
* Git, to show the repository's revision in program's `-V`

### Build

Read [this](build-aux/README.md).

## Run

All programs are set to be placed in `build/bin/<target cpu+os>`.

The universal usage documentation is [here](USAGE.md).

## Credits

* [@ikelaiah](https://github.com/ikelaiah) for cli-fp library. Part of it is used and modified.

## References

* Linux man pages
* GNU Coreutils [source code](https://github.com/coreutils/coreutils)
* Free Pascal's Run time [library](https://www.freepascal.org/docs-html/rtl/index.html) (RTL) and [Wiki](https://wiki.freepascal.org) and [docs](https://www.freepascal.org/docs.html)
* Procps-ng [source code](https://gitlab.com/procps-ng/procps)
* Free Pascal Compiler's [packages](https://gitlab.com/freepascal.org/fpc/source/-/tree/main/packages?ref_type=heads)
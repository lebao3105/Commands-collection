# Commands-collection

Build status:
[![Nightly CI](https://github.com/lebao3105/Commands-collection/actions/workflows/nightly.yml/badge.svg)](https://github.com/lebao3105/Commands-collection/actions/workflows/nightly.yml)

A collection of system commands written in Free Pascal.

They are:

* Programs put in `src` (sorry but I'm too lazy to update the list manually);
* UNIX-only (for now) programs that are seen in daily computer life
* Proof-of-concept (POC)s

They are NOT:

* Copycats (although some are intended to behave like original counterparts)
* Made to be laughed at
* Suitable for daily-use
* Fully optimized (atm)
* Object-oriented (although some like `TRegExpr` is used sometimes)
* Battle-tested

## Building

### Setup

Go install:

* FPC (Free Pascal Compiler) 3.x
* A C compiler - required C Standard version is unclear (undetermined?), but target C23 if you can
* Git, to show the repository's revision in program's `-V`
* My XMake [fork](https://github.com/lebao3105/xmake/tree/feat/fpcAdditions) for quicklier builds (without having to type much)

### Build

> Note: Assuming you've cloned the repository and `cd`'d into its root. Apply for all my projects:D

To set the program to build (there's no "all" target for now):

```
xmake f --target_program=<program_name>
```

Build using XMake as usual.

## Run

All programs are set to be placed in `build/<platform>/<architecture>/<build mode>`.

For example, [dir](src/dir) + Release build mode on x86_64 Linux:

```
xmake f -p linux -a x86_64 -m release --target_program=dir
xmake b -v
```

Will produce files in `build/linux/x86_64/release/`

The universal usage documentation is [here](USAGE.md).

Most programs have their own `--help` / `-h`.

## Credits

* [@ikelaiah](https://github.com/ikelaiah) for cli-fp library. Part of it was used and modified.
* Everyone who made resources for us to [refer](#references)
* [Ararslan] for their [termcolor-c](https://github.com/ararslan/termcolor-c/)

## References

* Linux man pages
* Windows API documentations
* GNU Coreutils [source code](https://github.com/coreutils/coreutils)
* Free Pascal's Run time [library](https://www.freepascal.org/docs-html/rtl/index.html) (RTL) and [Wiki](https://wiki.freepascal.org) and [docs](https://www.freepascal.org/docs.html)
* Procps-ng [source code](https://gitlab.com/procps-ng/procps)
* Free Pascal Compiler's [packages](https://gitlab.com/freepascal.org/fpc/source/-/tree/main/packages?ref_type=heads). FPMake source code and examples can be found there.
* [TRegExpr](https://github.com/andgineer/TRegExpr)

## TODO

* Complete existing commands
* Add man pages?
* Fix CI uploading - it's never been done properly
* Add tests
* If needed: add C. For example, ~~there is no `stdin` or `stdout` in Pascal~~ (I'm stupid, they are placed in system unit)
* Improve the program's performance
* Handle errors nicely
* Unicode support

# CC's build auxiliaries

The tool used to build Commands-Collection (CC for short, hope that doesn't confuse Makefile users) is fpmake.

Unusual placement of the tool - as it is normally seen in .. - but this is literally cleaner while still fits the role of fpmake.

This file covers its usage, and most importantly: its compilance. Yes - it is a bit compiler-dependent.

## How this works + Compiling

fpmake utilizes JSONs (and JSON schemas) to populate compiler options:

* Optimize level (omitted on debug builds, level 3 + strips + smartlinks on release);
* Unit outputs (.o, .ppu etc) path;
* Executable output path;
* Search paths;
* Add or not units used for debugging;
* Check for dependencies and download them if needed;
* Any other options as you wish.

Also fpmake reads [Targets.json](Targets.json) and your command line input to know what to compile, pack, and install. Targets.json serves as a database file.

Everything will be read and used by fpmkunit, the underlying build system.

Now to compile: download [this](https://gitlab.com/freepascal.org/fpc/source/-/tree/main/packages/fcl-jsonschema?ref_type=heads) folder, unpack, and run:

```bash
    fpc -Fu<unpacked folder / to / src> -dHAS_JSSC fpmake.pp
```

You may need to download more different folders, append more `-Fu` (NOT `-FU`)s. The mentioned folder must end with `src` (or contain `.pp` and / or `.pas` that is not `fpmake.pp`)

You don't need to do this on trunk FPC:

```bash
    fpc fpmake.pp
```

fpmake must be run on this folder!

## Usage

Some programs requires C - verify that by finding for C files: ones with '.h' / '.c' extensions.

If the target program indeed needs C, use your C compiler, tell it to compile [../include/custcustapp.c] into a shared library named `libcustcustc.so` (the extension will not be `so` on non-UNIX, e.g `.dll` on Windows or `.dylib` on macOS although it is UNIX-like).

The built library must be placed in a memorable place. It **IS** different for EACH PROGRAMS.

To build program(s) and/or unit(s):

```bash
    ./fpmake build --CompileTarget=<what to build, separated by commas>
    # to build everything
    ./fpmake build
    # if you love verbosity:
    ./fpmake build -v --CompileTarget=all
    # to build ones in ../include only:
    ./fpmake build -v --CompileTarget=all-units
```

If the program you want to compile uses C, pass `--options="-Fl<WHERE YOUR CUSTCUSTC IS, DIRECTORY PATH>"` into fpmake.

Afterwards, set `LD_LIBRARY_PATH` environment variable to custcustc folder too. Otherwise you'll get a symbol file error.

To clean:

```bash
    ./fpmake clean
```

To install:

```bash
    ./fpmake install -B <install path>
```

More can be known via `-h` / `--help`.

`--CompileTarget` is optional. Not providing it means you want fpmake to include all programs at once. You can also use this with `clean` or `install` tasks.

[CompileOptionsSchema.json](CompileOptionsSchema.json) can be used to create a CompileOptions.json, which will be used to manipulate some aspects of compilation.

`DEBUG` environment variable can be set to `1` to enable debug builds.

## Requirements

### OS

* CC is written and made to run on Linux;
* CC has a little bit of code for BSDs + Darwin;
* CC should run on many other UNIXes - some workarounds maybe required;
* CC does NOT compile on Windows! WSL doesn't count. Most stuff here is done using UNIX/POSIX functions.

Do not ask for support for dated/dead OSes / versions.

### A C compiler

> Note: Currently it is not needed right now. This section is kept as-is for future usage, if any.

It could be MSVC, CLang or GCC. A fairly recent compiler is recommended.

Right now CC still does not have the C standard version set. Will it only need C99? C11? Or even C23?

Try C1x or C23 if something goes wrong.

### A Pascal Compiler

Use FPC 3.3.1 or Trunk. Bold move I know.

Grab the compiler either from FPCUpdeluxe / https://freepascal.org.

Embarcadero's Delphi is not tested. This project does not use Delphi anyways.

Ensure that either `/etc/fpc.cfg` (Linux), `/usr/local/etc/fpc.cfg` (FreeBSD) or `~/.fpc.cfg` exists:
* Prebuilt packages normally include `/etc/fpc.cfg`;
* Tar installs from [freepascal.org](https://freepascal.org) will create one;
* FPC installed from FreeBSD's Ports, however, tells you:

<img width="850" height="581" alt="image" src="https://github.com/user-attachments/assets/78ca9f78-3c29-49dd-ac03-77c69c2bf87a" />

In most installations this is handled automatically and correctly by FPC/packagers.

### Libraries

* A C library (musl or not);
* RTL (run time library) and more from Free Pascal, see below.

> Note: Since FPC trunk is being used, skip the information below.
> To strip your FPC installation, you will want to modify its Makefile(.fpc)...

Default installation of FPC includes a lot of other unneccessary things, which can be skipped (mostly) on some Linux distributions. Here's what to install on Ubuntu-based distros, and maybe, Debian-based ones (Ubuntu is based on Debian):

* `fp-compiler`: The compiler
* `fp-units-base`: Some "base"(???) units, this includes Regexpr (for regular expressions)
* `fp-units-fcl`: Free Component Library, this includes process launcher classes
* `fp-units-misc`: Users and groups support
* `fp-units-rtl`: The Run Time Library (RTL)
* `fpc-source`: Source code of FPC (compiler, RTL, packages, utils) - OPTIONAL

CC in the past implemented a tool that can pull required packages from FPC's GitLab. Guess I should bring it back...

### Git

Of course. There may even be Git submodules to be cloned in the future.

### XMake

Install from https://xmake.io.

## Building CC

Assuming you've cloned the repository and `cd`'d into its root. Apply for all of my projects:D

### XMake

In some places like Haiku OS and MSYS2, run this first to let XMake know where the compiler is:

```bash
$ xmake f --pc=$(which fpc) --pcld=$(which fpc)
```

Replace `$(which fpc)` with either the full path of FPC or your preferred way of finding FPC.

This is also required if you want to use another compiler that is not on PATH.

To build a specific program:

```bash
$ xmake b <program_name>
```

To build everything:

```bash
$ xmake
# or
$ xmake b
```

To build all programs:
```bash
$ xmake b programs
```

Add `-r` for rebuilds, needed for new changes.

To clean:

```bash
$ xmake c
```

To create and consume debug builds, use `xmake f -m debug`.

To create and consume release builds, add `xmake f -m release`.

### Other build tools

There are none:D

## Running built programs

All programs are set to be placed in `build/<platform>/<architecture>/<build mode>`.

For example, dir + Release build mode on x86_64 Linux:

```
xmake f -p linux -a x86_64 -m release
xmake b -v dir
```

The executable will be put in `build/linux/x86_64/release/`.

Most programs have their own `--help` / `-h`.

## Packaging CC

Run:

```
xmake pack -y -f [format]
```

Supported formats:

* tar.gz archive
* tar archive
* deb
* rpm
* zip archive
* dmg (for macOS)
* and maybe more...

All are put in `build/xpack/commands-collection`.

# Commands-collection vUPCOMING

## New features

### Windows

Windows support has been added to CC!
Modifications have been made to CC in order to be compatible with different API sets.

There is no known runtime differences at the moment.

## For developers+maintainers

### API changes

* `cc.registry` unit has been added for Windows Registry system usage.
* A new function named todo() has been added to mark TODO works.
* SetLastErrno() has been implemented in `cc.logging`.

## Build system changes

### New XMake tasks

Document and i18n XMake targets are now XMake tasks. 2 new commands:

```bash
$ xmake i18n [task] [target]
```

and

```bash
$ xmake docs [task] [target]
```

Check out their `--help` for more infomations.

Also usages of XPack have been removed as I want to have more control over packaging scripts (in this case, `debian/control`). Instead, one can use `xmake install` now.

### Platform-specific API

XMake can now detect platform specific units and add them to API target if able to.
Read the updated CONTRIBUTING.md.

### Better file tracking

(applies to program targets only)

XMake now not only checks for changes in the main file passed to target's `add_files()` but also other program-specific and CC shared code.
RTL, FCL and more however are not tracked.
This requires a tool named ppudump, which comes with FPC.

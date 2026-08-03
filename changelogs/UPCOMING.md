# Commands-collection vUPCOMING

## New features

### Windows

Windows support has been added to CC!
Modifications have been made to CC in order to be compatible with different API sets.

There is no known runtime differences at the moment.

## Program-specific changes

* inp: Removed -s, -e and -o flags. May the removal of -s be temporary?
* inp, env, rm: Use i18n [unit](../src/shared/i18n.pp) instead of including i18n.inc
* dir: Added more settings. It will raise an exception if DIR_PRESET is not one of the predefined names
* dir: Read settings from DIR_CONF file before parsing command-line arguments
* dir: Do not print directory size as it's not implemented
* dir: Footer (which shows ignored file count etc.) is now optional

## For developers+maintainers

### API changes

CC's [shared](../src/shared/) code has been moved to a separate project called sma11.
Below is what the new library offers since v262305:

* A new unit has been created for Windows Registry tasks
* A new function named todo() has been added to mark TODO works.
* Refactored TFSProperties, and it's iterable now!
* Added ability to set last error code
* Usage of CRT is, once again, removed.

### Changed i18n location

All programs now have their files put in [/i18n](../i18n), instead of their own directory.

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

### Miscs

* Helper functions and tasks are now moved to a separate project
* output-prefix option will now affect manual page names

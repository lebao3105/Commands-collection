# Commands-collection vUPCOMING

## New features

## Fixes

## For developers+maintainers

### Build system changes

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

### API changes

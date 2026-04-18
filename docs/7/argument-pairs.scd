ARGUMENT_PAIRS_IN_COMMANDS_COLLECTION(7)

# EXAMPLE

Considering this rename(1) call:

rename --use-paris bye hello home world lol

rename will then rename:

- bye to hello;
- home to world.

bye-hello, home-world are argument pairs.

"lol" has no match available, and rename will throw a warning on it.

# DESCRIPTION

CC has a special feature: (command-line) argument pairs.

Look at the example above. There are 2 pairs of arguments, each has 2 arguments inside.
Packed values like this can be quite useful, not only in cases of renamings like that, but also in cases like this:

```
vcs commit --use-pairs src/cc.base.pp "fix: Swapped TResult types"
                       src/dir/       "feat: LS_COLORS!"
                       README.md      "Update README.md"

    (to commit new changes, using path - message pairs)
```

```
cook put --use-pairs  project1    install_prefix1
                      project2    install_prefix2

    (to install projects into their corresponding install folder)
```

CC lets you put flags with their values (if any), safely:

```
rename --use-pairs one two three --interactive y four
```

That "y" is for --interactive. CC won't put it into any argument pairs.

# USAGE

Not all programs in CC support, or say, need this feature. Run a program with --help or -h and see if the output has:

```
    --use-pairs         Read pairs of X arguments.
```

If there is, the program supports pairs!

Not always a pair needs 2 values. It can be 3, or even more. But will never be one or lower.

For specific usage of pairs for each program, consult its documentation.

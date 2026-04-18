DIR(1)

# NAME

dir - list directory contents

# SYNOPSIS

dir [OPTIONS] [DIRECTORIES...]

# DESCRIPTION

dir lists directory contents. By default it prints object names only (column/space separated).

Use the list option (-l / --list) to obtain a detailed, one-entry-per-line listing. Several detailed output formats are available.

# OPTIONS

-l, --list
Show the output as a list (one entry per line with details).

-a, --all
Show everything including hidden files and folders (names starting with a dot).

-c, --color
Use colors in the output when supported by the terminal.

-d, --directory
Only show directories (do not list regular files).

-i, --ignore PATTERN
Ignore entities matching PATTERN. The pattern is interpreted as a regular expression (TRegExpr implementation).

-B, --ignore-backups
Ignore entries whose names end with a tilde (~) or .bak.

-R, --recursive
List directory contents recursively.

# FILE TYPE CHARACTERS
Detailed formats encode an entry's kind using a single leading character. This applies to UNIX and Commands-Collection formats.

d : Directory

s : Socket

l : Symbolic link

b : Block device

p : Pipe (FIFO)

c : Character device

\- : Regular file

? : Unknown or stat failure

# PERMISSIONS

Permissions are presented as three triplets (owner, group, others). Each triplet contains r when readable, w when writable, x when executable and - when the respective permission is absent.

# EXAMPLES

List current directory in name-only mode:

    $ dir

List everything including hidden items in detailed GNU format:

    $ dir -a -l -u

Recursively list directories only, ignoring backup files:

    $ dir -R -d -B

# ENVIRONMENT VARIABLES

DIR_PRESET holds the target output preset that dir uses. Currently there are 4 values you can choose:

- win: Let dir mimic Windows's dir output;
- gnu: Let dir mimic GNU's ls output;
- ccd or empty: Let dir use its own output style.

DIR_CONFPATH holds the location of the settings file for dir.

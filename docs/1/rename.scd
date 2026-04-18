RENAME(1)

# NAME

rename - rename files and directories

# SYNOPSIS

**rename** [OPTIONS] FROM TO...

# DESCRIPTION

Do we really need a description for this one?

# OPTIONS

*-s, --symlink*
	Follow symbolic links.

*-d, --dry-run*
	Show what would be renamed without making changes.

*-b, --bulk*
	Replace all occurrences of the pattern.

*-r, --regex*
	Treat PATTERN as a regular expression.

*-o, --no-overrides*
	Do not overwrite existing files.

*-i, --interactive*
	Ask before renaming each file.

*-l, --last*
	Replace only the last occurrence in each path.

*-k, --keep-attributes*
	Preserve file attributes.

*-p, --opposites*
	Operate on files that do not match the pattern.

*-v, --verbose*
	Output detailed operation information.

*--use-pairs*
	Use pairs of 2 command-line arguments. See argument-pairs(7).

# EXAMPLES

Rename all .txt files to .bak:

	$ rename .txt .bak *.txt

Use regex to rename files:

	$ rename -r '(\w+)\.txt' '\1.bak' *.txt

Rename bye to hello, home to world:

	$ rename --use-pairs bye hello home world

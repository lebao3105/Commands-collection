RM(1)

# NAME

rm - remove files and directories

# SYNOPSIS

**rm** [OPTIONS] FILES...

# OPTIONS

*-g, --ignore*
	Ignore files matching the filter and do not delete them.

*-d, --dry-run*
	Show what would be removed without changing anything.

*-x, --filter* PATTERN
	Filter files by regular expression before removing.

*-r, --recursive*
	Remove directories and their contents recursively.

*-k, --keep-going*
	Continue despite errors.

*-v, --verbose*
	Print information about each removed item.

# EXAMPLES

Remove a file:
```
	$ rm file.txt
```

Remove a directory recursively:
```
	$ rm -r folder/
```

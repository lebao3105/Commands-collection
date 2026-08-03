TOUCH(1)

# NAME

touch - create files and directories

# SYNOPSIS

**touch** [OPTIONS] FILES...

# DESCRIPTION

**touch** creates files and directories.

# OPTIONS

*-p, --parent*
	Create parent directories if they do not exist.

*-d, --create-dirs*
	Create directories instead of files.

*-v, --verbose*
	Print details about created items.

*--use-pairs*
	Use pairs of path-type. *-d* will be ignored.

# EXAMPLES

Create a file:
```
	$ touch file.txt
```

Create path/ (folder), path/to/ (folder), then path/to/file.txt (file):
```
	$ touch -p path/to/file.txt
```

Create a directory explicitly:
```
	$ touch -d newdir/
```

Create files *and* folders:
```
	$ touch --use-pairs file.txt    f \
			--parent	path/to/dir d
			--verbose
	Created file file.txt.
	Created folder path.
	Created folder path/to.
	Created folder path/to/dir.
```

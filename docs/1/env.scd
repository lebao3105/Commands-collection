ENV(1)

# NAME

env \- run a program with modified environment or query variables

# SYNOPSIS

env [OPTIONS] PROGRAM ARGS...

# DESCRIPTION

env prints environment variables or runs a program with modified environment variables.

# OPTIONS

-g, --get VAR
Print the value of the specified environment variable.

-s, --set VAR=VALUE
Set the specified environment variable for the executed program.

-u, --unset VAR
Unset (remove) the specified environment variable for the executed program.

# EXAMPLES

List all environment variables:

    $ env

Print the value of a single variable:

    $ env -g PATH

Run a program with a modified environment variable:

    $ env -s "FOO=bar" ./myprog arg1 arg2

Unset a variable for the executed program:

    $ env -u HOME ./myprog

# NOTES

When run with no program specified, env prints specified, or all the current environment variables.

When used to run a program, environment modifications apply only to the executed program and its children; they do not change the caller's environment.

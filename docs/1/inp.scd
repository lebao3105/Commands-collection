INP(1)

# NAME

inp \- prompt for a key or input and exit with its character code

# SYNOPSIS

inp [OPTIONS]

# DESCRIPTION

inp displays a message and waits for a key or input. The program exits with the ASCII value of the entered character (or a non-zero code if input is unexpected).

# OPTIONS

-c, --message  MESSAGE
Set a custom message to display.

-d, --hide-input
Do not echo the keyboard input as it is typed. Characters will not be shown or replaced by placeholders such as "*".

-e, --need-enter
Require the Enter key after the input character. Use this when you need an explicit confirmation step from the user; it can be combined with other options (for example, prompting for a key and then requiring Enter to verify).

-k, --key  CHARACTER/STRING
Specify accepted key(s). Can be used multiple times.

-l, --loop
Keep prompting until an accepted key is pressed.

-o, --show-availables
Show the available accepted keys in the prompt.

-s, --case-sensitive
Make key matching case-sensitive.

# EXAMPLES

Prompt with a custom message and accept only 'y' or 'n':
```
    $ inp -c "Continue?" -k y -k n
    Continue? [yn] y
    $
```

Hide input while the user types (useful for passwords or sensitive keys). Note: characters are not echoed or replaced by stars:
```
    $ inp -d -c "Enter PIN:"
    # Prompt appears; typed characters are not shown
    $
```

Require the user to press Enter after the key (useful when you want an explicit verification step):
```
    $ inp -e -k q
    Press Enter after q
    $
```

Keep prompting until one of the accepted keys is pressed (example transcript showing repeated prompts):
```
    $ inp -l -k y -k n -o -c "Are you sure?"
    Are you sure? [yn] x
    Are you sure? [yn] no
    Are you sure? [yn] y
    # exits with code for 'y'
    $
```

Display available accepted keys in the prompt:
```
    $ inp -o -k y -k n -c "Continue?"
    Continue? [y] y
    $
```

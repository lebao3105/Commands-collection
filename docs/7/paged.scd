PAGED_COMMANDS_COLLECTION(7)

# DESCRIPTION

Commands-Collection can create so-called paged views, which is scrollable,
has a search tool, can jump to specified line, can even highlight texts for you.

Technically, this is done by:

- Editing your console attributes, temporary;
- Using escape sequences;
- Clear the screen and rewrite everything when needed.

This is used for cases like printing a wall of text, e.g help messages.
Very, very, very useful for TTYs, which are normally not scrollable; or when your mouse
died and you don't know how to scroll the terminal (in Konsole, it's Shift + Up/Down by default, 
thank me later).

CC programs bundle this feature by default.

# ENVIRONMENT

These must be set before the program runs, or at least before any pager function runs.

0. Data types and their possible values
	- Boolean: `true`, `false`
	- Default: empty value or `default`
	- Numbers (integers, floats etc)
	- String

1. PAGER_TOGGLE
	- Is a boolean;
	- Decides whether the pager should be used or not.

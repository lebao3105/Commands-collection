Welcome to the Commands-collection wiki!

This documentation is made for:

* Q&As;
* Contributors;
* People who wants to build CC;
* Distribution maintainers.

For regular users, there are man(ual) pages for each available program.

## Q&A

Q: Will this support Linux?

A: CC supports Linux since day 0.

Q: Will this support Windows?

A: Yes, but it's not my main priority. I'm happy with Linux.

Q: The syntax of [X] is unfamiliar - how can I use the program with this?

A: If you find options of a program too complex for nothing, tell us via GitLab's Issue board. Otherwise: learn...it? CC does not aim to replace your daily-use collections like GNU CoreUtils or UUtils - so we have more freedom to do anything we see fit.

Q: [Programming scope] Why Pascal?

A: It's one of my first projects. You may treat this as a hobby/proof-of-concept project. Also...we are too familiar with C tools, I guess???

Q: [Programming scope] How much OOP is used here?

A: I don't know why you ask this, but there are a few:
* Objective Pascal mode must be used for stuff like array of `const` (primary used for text formatting)
* Static `record` function requires `class` keyword, which is not present until the use of `{$modeswitch result}`
* RTL (run time library) and FCL (Free Component Library) has useful stuff that is OOP

While the use of RTL and FreePascal's bundled packages are totally not
avoidable, reinventions may be made to suit our need, especially for simplicity and speed.

Q: [Programming scope] Your code doesn't look like Pascal!

A: Which part? Only some keywords (under 5) and types get aliased.
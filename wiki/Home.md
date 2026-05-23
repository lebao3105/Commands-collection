Welcome to the Commands-collection wiki!

This documentation is made for:

* Q&As;
* Contributors;
* People who wants to build CC;
* Distribution maintainers.

For regular users, there are man(ual) pages for each available program.

From now on, call this project CC for short.

## Introduction

CC is a pack of command-line programs, varying from:

* Listing content of a directory;
* Getting basic information of your machine and running OS

To:

* Creating/Removing/Renaming files and folders;
* Creating interactive prompts (Are you sure? question and more);
* Launching programs with modified environment variable.

Some CC programs do work the same way as their original counterpart: uptime and uname are 2 examples.
Other programs do not need to do so, as CC does not care about replacing GNU Coreutils and such.

CC is:

* Customizable in its own way, from source code to run-time;
* Able to handle regular expressions (not all program need this);
* Able to create pairs of command-line arguments, check out our cc-argument-pairs(7) manual page;
* [Not implemented] Able to make its program's `--help` and more scrollable;

Expect unfamiliar interactions with CC programs.

## Platform support

* Linux
* Planned: BSD. While most programs work, some may require workarounds.
* Planned: macOS, need maintainers
* Planned: Windows, need maintainers (I do still have Windows installed, but spend little to no time with it)
* Planned?: ReactOS. This one is really insteresting and I want to give it something\*
* Planned?: HaikuOS. Another interesting OS - you can see stuff from Linux and BSD here, e.g GCC and Firefox, (almost) up-to-date!

\* No, I do not want to make CC a replacement of any OS's utility pack.

But making this to work on an OS like ReactOS will promote the OS to more people, right? I like it.

## Q&A

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

## Versioning system

CC follows this YYMMDD\<branch\> for versions, where \<branch\> is one of:

* a[lpha]
* b[eta]
* r[elease candidate]
* empty means stable.

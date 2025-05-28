# Usage

Thank you for installing this product. Here goes a quick, universal guide for all programs made by Commands-Collection team.

## Launch a shell with Commands-Collection in `PATH`

> Note: this is Windows only for now.

Make sure you enable "Install Start Menu/Desktop/Task bar shortcuts" option first.

Then, using any way you please, open CommandsCollection. A Command Prompt window will show up, telling you it has `%PATH%` variable updated for Commands-Collection programs.

From now on, we assume you have Commands-Collection mentioned in your `%PATH%`.

## Arguments and flags

Flags sets different stuff of the program.

There are "short" flags starting with a `-` and a **single** character; and "long" flags which start with 2 `-`s and whatever name the developer see fit and short enough (what? who would not want them to be short for typing while mantaining verbosity?).

For all programs, `-h` and `--help` are enabled. They show the program's help message, of course.

Because of the API we used for command-line parsing (or we do not look at its code that many to point out the right thing to set), passing flags with values do not totally confortable.

You can not combine short flags like this:

```bash
dir -la
```

You need to do this instead:

```bash
dir -l -a
```

With that `dir` will show all files and folders as you wish.

Pass values to long flags like this:

```bash
env --get=HOMEPATH
```

Not this:

```bash
env --get HOMEPATH
```

However this does not apply to short flags:

```bash
env -g HOMEPATH # Works
```

## Quick FAQ

<details>
<summary>Q: Assertion error / Exceptions that do not even relate to the purpose of the application</summary>

A: Report that to us.
</details>

<details>
<summary>Q: The program throws help message at launch</summary>

A: Read it. If there are yes/no typo from either side or you think it **really** should not happened, tell us.
</details>

<details>
<summary>Q: Can I daily-use this project?</summary>

A: Hell no. These are too basic for that.
</details>

<details>
<summary>Q: Can I be a r/masterhacker with these?</summary>
<details>
<summary>A: Yes.</summary>

(that subreddit mocks all of you who ask that stupid question.<br>
 go touch grass idiot. we give a shit about doing hacking stuff.)
</details>
</details>

<details>
<summary>Q: Linux? UNIX?</summary>

A: We already have it long ago. Just no installation script.
</details>

## What's next?

Program-specific documentaion are available in [docs/] or their own help messages.

Now use programs the way you wish.

Welcome to Commands-Collection!
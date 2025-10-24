# Usage

Thank you for installing this product. Here goes a quick, universal guide for all programs made by Commands-Collection team.

## Launch a shell with Commands-Collection in `PATH`

Make sure you enable "Install Start Menu/Desktop/Task bar shortcuts" option first.

Then, using any way you please, open CommandsCollection. A CMD window will open, telling you that `%PATH%` has been updated.

That's what you will do on Windows.

## Arguments and flags

Flags sets different stuff of the program.

* Short flags begin with `-`, following by a character.
* Long flags begin with `--`.

For all programs, `-h` / `--help` are available.
They show all available flags and more informations.

`-V` and `--version` are also available for project/program version.

From now on, short flags will be referred in most documents.

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

A: Hell no.
</details>

<details>
<summary>Q: Can I be a r/masterhacker with these?</summary>
<details>
<summary>A: Yes.</summary>

(for those who don't know: r/masterhacker is a subreddit that is NOT
 about any **actual** hacking stuff, it instead shows pictures of kids
 running `sudo apt update` and say that "Hey, I'm a hacker now". We,
 Commands-Collection developers, do NOT have any command that can attack
 your/others computer. Do not even ask for one. We're busy completing
 existing ones. Thank you.)
</details>
</details>

<details>
<summary>Q: Can I run this on X platform?</summary>

A: Depends. While we make build script(s) that allows you to build Commands-Collection
for your desired platform (supported ones can be seen at the very top of [Makefile](Makefile)),
there is no gurantee that all commands work well on all platforms.

If you're new to Linux / BSD:
<details>
<ul>
<li>So-called distros, or distributions, exist. Linux in fact is a **kernel**, the heart of the entire
operating system that manages services, provides a set of APIs that Commands-Collection and other
things to use (for example, to delete a file or shutdown your device).</li>
<li>"Linux" that you, we, everyone heard of, refer and use is the Linux **kernel** with a lot of stuff,
from GNU coreutils / UUtils to desktop environments like GNOME or KDE. People - including YOU - do
anything they want: apply patches to source code, generate their own packages and host them somewhere,
create ISOs that yes, a distribution!</li>
<li>One distribution can base on another distribution. The most well-known, and also the..."fattest" (NOT
kidding, you'll see it by yourself) one, Ubuntu, is based on Debian. Linux Mint, which is a lot more user-
friendly (especially ones from Windows) is based on Ubuntu. Can does not mean must - one can be a fully
independent distro. You can make one - Linux From Scratch for example.</li>
<li>Android is a Linux distribution, while Apple OSes are not.</li>
<li>Distribution exists in BSD world.</li>
<li>Due to the term of "distributions", Commands-Collection and many other programs should work on yours.</li>
</ul>
</details>

If you wonder how this works on Windows:
<details>
By calling Windows API exposed to Free Pascal's RTL via `Windows` unit.
</details>

</details>

## What's next?

Program-specific documentaion are available in [docs/](docs/) or their own help messages.

Now use programs the way you wish.

Welcome to Commands-Collection!

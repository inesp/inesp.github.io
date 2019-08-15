---
title: "Git cheat-sheet: Aliases"
biblio:
  - title: "StackOverflow: Pretty git branch graphs"
    link: "https://stackoverflow.com/questions/1057564/pretty-git-branch-graphs?page=1&tab=votes#tab-top"
---

The only times, I feel like a hacker, a movie hacker, is when I suddenly notice that I've been writing git commands for "I don't know how long". Git is so simple and so easy to use and so elegant and I wouldn't call it too verbose at all and still, I am regularly caught up in between git commands.

As much as I fancy looking like a TV hacker, I still decided to change the essays I write to command line into short poems.

#### Level 1 aliases

These are just about replacing 1-short-word with 1-shorter-word.

The first thing to shorten is the `git` command itself. In `~/.bashrc` (or somewhere else) one would add:

```bash
alias g="git"
```

*Don't forget to run `source ~/.bashrc` after every change to `.bashrc`.*
{:.small}

From now on `g` is your `git` and all the commands instantly become shorter: `g status`, `g commit`, `g checkout`.

Next, I've looked at the most common `git` commands I am using and have set up git aliases for them:
```bash
g config --global alias.br branch
g config --global alias.a add
g config --global alias.aa "add ."
g config --global alias.co checkout
g config --global alias.ci commit
g config --global alias.cim "commit -m"
g config --global alias.s status
g config --global alias.p push
```

The results of this change are commands like `g br` instead of `git branch` and `g ci -m "Fix something"` instead of `git commit -m "Fix something"` and `g s` instead of `git status`.

#### Level 2 aliases

These can be troublesome to set up. Some of them have will only work inside a specific context.

##### `git lg`

The most famous one is probably the `lg` command. Everybody is using it and I have absolutely no idea, where I got it from. Several versions of it exist, but they are all visualizing the git history as a graph:

![git lg](/assets/git-lg.png)

To set up `g lg` it might be easier to modify the `~/.gitconfig` file instead of calling the `git config` command.

For the above result, I've set up the below alias and called `g lg`.
```bash
[alias]
  lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
```

Alternatively, a slightly different print is bellow:
```bash
[alias]
 lg2 = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr - %C(magenta)%cD%Creset) %C(bold blue)<%an>%Creset' --abbrev-commit
```

![git lg 2](/assets/Git-lg-2.png)
 
##### `git afa`

A common workflow at my current team is to amend existing commits. Sometimes we strive to create a clean git history by squashing certain commits together. The only problem is that it takes a few commands to accomplish and it gets awfully repetitive over time.

Git already supports this process. By calling `git commit --fixup 4dfa2350` a new commit is created, which can later be autosquashed.

If this is our current history:
```bash
$ git lg -3
* 276a275 - (HEAD -> master) Commit C (9 minutes ago) <ines>
* deecdf2 - Commit B (10 minutes ago) <ines>
* 045f234 - Commit A (10 minutes ago) <ines>
```
and we modify the file `file_A.jpg` and call 
```bash
$ git add file_A.jpg
$ git commit --fixup 045f234
```
a new commit is created and it looks like this:
```bash
$ git lg -4
* af7c976 - (HEAD -> master) fixup! Commit A (15 seconds ago) <ines>
* 276a275 - Commit C (12 minutes ago) <ines>
* deecdf2 - Commit B (12 minutes ago) <ines>
* 045f234 - Commit A (13 minutes ago) <ines>
```
.

The next thing to do would be to rebase the commits:
```bash
$ git rebase -i --autosquash
```
which opens the window:
```vim
  pick 045f234 Commit A
  fixup af7c976 fixup! Commit A
  pick deecdf2 Commit B
  pick 276a275 Commit C
```
. As you can see our newly created commit is already marked that it will modify *Commit A*.

But as I said, this is a lengthy affair, thus I have set up the following aliases to make the process shorted:

```bash
[alias]
  f = "!f() { git commit --fixup $1;}; f"
  fa = "!f() { git commit --fixup $1; git rebase -i --autosquash $1^; }; f"
  afa = "!f() { git add .; fir commit --fixup $1; git rebase -i --autosquash $1^;}; f"
```
 `g f xxx` only creates the desired commit, `g fa xxx` also triggers a rebase and `g afa xxx` first commits all files before it creates a fixup-commit and triggers a rebase.


##### `git cog`

Last but not least is my grep-ified checkout command:

```bash
[alias]
  cog=!sh -c "git branch | grep '$1' | head -n1 | awk '{print $2}' | xargs git co "
```

I don't know about you, but I really do not manage to keep the number of my local branches below 15. If they are only at 15, I am actually pretty happy. There are always 1 or 2 big ones, from which I am splitting of commits for actual pull requests, then there are a few of open pull requests in review, then there are a few experimental ones and a few, where I am researching something or preparing a presentation for something, then there are many from other team members, which I daily review, ... . Maybe I'm just bad at cleaning up or I just take up too much work. Anyway, I set up the above command to help me out.

The above command runs `grep` over the list of all my git branches and checkouts the first one, which has the provided string in its name. Example:

```bash
ines: ~/repo (master)$ g br
  feature-JIRA123
  feature-JIRA5678
  poc-clouds-blue
  poc-light-green
* master
  pr-1010

ines: ~/repo (master)$ g cog "blue"
Switched to branch 'poc-clouds-blue'

ines: ~/repo (poc-clouds-blue)$ g br
  feature-JIRA123
  feature-JIRA5678
* poc-clouds-blue
  poc-light-green
  master
  pr-1010
```

Hopefully, some of these commands are helpful to you. At the very least, they show that any kind of workflow can be fully or partially automated.

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

*Don't forget running `source ~/.bashrc` after every change to `.bashrc`.*
{:.small}

From now one `g` is your `git` and all the commands instantly become shorter: `g status`, `g commit`, `g checkoout`.

Next, I've looked at the most common `git` commands I am using and have set up git aliases for them:
```bash
g config --global alias.br branch
g config --global alias.a add
g config --global alias.co checkout
g config --global alias.ci commit
g config --global alias.s status
g config --global alias.p push
```

The end result of this change are commands like `g br` instead of `git branch` and `g ci -m "Fix something"` instead of `git commit -m "Fix something"` and `g s` instead of `git status`.

#### Level 2 aliases

These are a bit more advanced. Setting them on the first time demands a bit of trial and error.

The most famous one is probably the `lg` command. Everybody is using it and I have absolutely no idea, where I got it from. There are several versions of it, but they are all visualizing the git history as a graph:



```bash
git lg
```

```bash
alias.lg
```

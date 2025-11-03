---
title: "Git script <code>git rebaseToMaster</code>"
tags: ["Git", "Tools"]
excerpt_separator: <!--more-->
---

There's too many people on my project. 😅

I'm not complaining, but I did have to `rebase` my code to `master` a LOT. 

And it's always the same 5 lines (or so), so I wrote myself a little shortcut and transformed it into a git "alias". 🍰

<!--more-->

Here's the excerpt from my `.gitconfig` file:
```bash
[alias]
  rebaseToMaster = "!f() { git add . && git commit -m wip --allow-empty && git co master && git pull && git reset --hard origin/master && git co - && git rebase -i --autosquash master && git reset HEAD~1; }; f"
```
(works on my machine 😅)

#### Step by step explanation:

1. `git add .` - add all changed files
2. `git commit -m wip --allow-empty` - create a commit with the message "wip" (work in progress), allow empty is added, because sometimes I am in the middle of some work, other times I am not
3. `git co master` - switch to the `master` branch
4. `git pull` - pull the latest changes from the remote `master` branch
5. `git reset --hard origin/master` - reset the local `master` branch to the remote `master` branch
6. `git co -` - switch back to the branch you were on before
7. `git rebase -i --autosquash master` - rebase your branch to the `master` branch
8. `git reset HEAD~1` - remove the temporary commit you made in step 2
9. 🎉


Now I can be in the middle of a taking apart the whole application and can still `rebase` to `master` quickly and nonchalantly.

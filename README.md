Ines's Blog.


## Setup dev env

GitHub Pages does NOT support the latest Ruby nor the latest Jekyll nor every Jekyll gem. Supported versions: https://pages.github.com/versions/

### Prerequisites

1. **Install Ruby** - version must match `.ruby-version` file

   Using [rbenv](https://github.com/rbenv/rbenv) (recommended):
   ```bash
   # Install build dependencies (Ubuntu/Debian)
   sudo apt install build-essential libssl-dev libreadline-dev zlib1g-dev libyaml-dev libffi-dev

   # Install rbenv (or update if already installed)
   git clone https://github.com/rbenv/rbenv.git ~/.rbenv 2>/dev/null || git -C ~/.rbenv pull

   # Add to your shell (add this line to ~/.bashrc)
   eval "$(~/.rbenv/bin/rbenv init - bash)"

   # Reload shell config (or restart your shell)
   source ~/.bashrc

   # Install ruby-build plugin (or update it)
   git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build 2>/dev/null || git -C ~/.rbenv/plugins/ruby-build pull

   # Install the Ruby version from .ruby-version (takes several minutes - compiles from source)
   rbenv install
   # For a new project without .ruby-version, specify version explicitly:
   # rbenv install 3.3.4
   ```

   rbenv automatically switches to the correct version when you `cd` into the project.

2. **Install Bundler**
   ```bash
   gem install bundler
   ```

3. **Configure Bundler** to install gems locally (avoids permission issues)
   ```bash
   bundle config set --local path 'vendor/bundle'
   ```

4. **Install gems**
   ```bash
   bundle install
   ```
   or
   ```bash
   make upgrade
   ```

### Running locally

```bash
make up        # Dev server with future posts, live reload
make up-prod   # Production-like (no future posts)
```

Site will be at http://localhost:4000

### Updating dependencies

```bash
make upgrade       # Update gems only
make upgrade-ruby  # Update Ruby version to match GitHub Pages
make upgrade-all   # Update both Ruby and gems
```

After upgrading, commit `Gemfile.lock` and `.ruby-version`.

## Deployment

Pushes to `master` automatically deploy via GitHub Actions (`.github/workflows/deploy.yml`).

## Draft branches and the private backup repo

This repo is public (GitHub Pages requires it), so every branch pushed to `origin` is public, including half-written drafts. To keep drafts private but still backed up off this machine, there is a second, private repo: `inesp/blog-drafts`. It is just a dumb bucket for branches, it never deploys anything.

### One-time setup (new machine, or if the private repo is gone)

```bash
# create the private repo (empty, no README - it must have no history of its own)
gh repo create inesp/blog-drafts --private

# register it as a second remote named "private"
git remote add private git@github.com:inesp/blog-drafts.git
```

If `git remote -v` already lists `private`, setup is done.

### Day to day

```bash
make draft      # push the branch you are on to the private repo
make draft-all  # back up all local branches to the private repo
make rebase     # rebase the branch you are on onto latest master
make publish    # push master to origin = deploy the public site
```

Rule of thumb: work on a draft branch, `make draft` as often as you like, and only merge to `master` + `make publish` when the post is ready for the world. Nothing reaches the public repo unless you explicitly push to `origin`.

### Rebasing a draft

When master has moved on (a post got published) and a draft branch is behind, check out the draft and run `make rebase`. It fast-forwards local `master` from GitHub and replays the draft on top, no need to check out master yourself.

If the rebase hits conflicts, git stops mid-rebase and waits: fix the conflicted files, `git add` them, then `git rebase --continue`. To bail out and return to exactly where you were, `git rebase --abort`.

A rebase rewrites the draft's commits, so the next `make draft` has to overwrite the branch in the private repo. The `draft` target uses `--force-with-lease` for this: it only overwrites what this machine last saw, which is safe in a single-person backup repo.

### Maintenance

The private repo accumulates old branches forever, and that is fine. If it bothers you, delete merged ones with `git push private --delete <branch>`. If the two repos ever feel out of sync, run `make draft-all` and the private repo is complete again, it needs no other care.

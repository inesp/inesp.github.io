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

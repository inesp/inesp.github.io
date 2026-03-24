up: 
	bundle exec jekyll serve --future --livereload --trace

up-prod:
	bundle exec jekyll serve

upgrade:
	bundle update

upgrade-ruby:
	@echo "Fetching GitHub Pages Ruby version..."
	@curl -s https://pages.github.com/versions.json | grep -o '"ruby":"[^"]*"' | cut -d'"' -f4 > .ruby-version
	@echo "Updated .ruby-version to $$(cat .ruby-version)"
	@echo "Installing Ruby (this takes several minutes)..."
	rbenv install --skip-existing

upgrade-all: upgrade-ruby upgrade

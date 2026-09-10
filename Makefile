up: 
	bundle exec jekyll serve --future --livereload --trace

up-prod:
	bundle exec jekyll serve

upgrade:
	bundle update

check-links:  ## verify all prev_post/next_post series links point to real, reciprocal posts
	ruby scripts/check_series_links.rb

upgrade-ruby:
	@echo "Fetching GitHub Pages Ruby version..."
	@curl -s https://pages.github.com/versions.json | grep -o '"ruby":"[^"]*"' | cut -d'"' -f4 > .ruby-version
	@echo "Updated .ruby-version to $$(cat .ruby-version)"
	@echo "Installing Ruby (this takes several minutes)..."
	rbenv install --skip-existing

upgrade-all: upgrade-ruby upgrade

draft:  ## push current branch to the private drafts repo
	git push private HEAD

draft-all:  ## back up all branches to the private drafts repo
	git push private --all

rebase:  ## rebase current draft branch onto latest master
	git fetch origin master:master
	git rebase master

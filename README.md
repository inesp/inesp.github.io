Ines's Blog.


## Setup dev env


GitHub Pages does NOT support the latest Ruby nor the latest Jekyll not every Jekyll gem. Here is a list of the gems and their versions, which are suppoerted on GitHub Pages: https://pages.github.com/versions/

- Install Ruby (last I checked GitHub Pages is using Ruby 2.5.3). Don't forget to run `source ~/.bashrc` to load the new $PATH values
- Install Bundler (a Ruby gem): `gem install bundler`
- Install all the gems in the `Gemfile`: `bundle install`
- Run the server `bundle exec jekyll serve --future`


Jekyll is a Ruby's gem. All the gem's you will use to run your site have to be listed in the `Gemfile`.

### Updating gems

Every so often run `bundle update -all`.


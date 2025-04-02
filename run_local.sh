# to run the site locally, use the following commands (assuming you have chruby and ruby-install)

ruby-install ruby 3.3.5
chruby ruby-3.3.5
gem install bundler
bundle install
bundle exec jekyll serve --livereload

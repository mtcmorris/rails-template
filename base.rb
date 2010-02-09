gem 'rspec', :env => :test
gem 'rspec-rails', :env => :test
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com', :env => :test
gem 'cucumber', :env => :test

generate :rspec
generate :cucumber

run 'rm public/javascripts/*'
plugin "jrails", :git => "git://github.com/aaronchi/jrails.git"

git :init

file ".gitignore", <<-END
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
.DS_Store
log/*.log
tmp/**/*
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"

git :add => "."
git :commit => "-m 'initial commit'"


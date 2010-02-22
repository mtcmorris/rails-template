project_dir = root.split('/').last


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

# download Blueprint
run 'rm public/stylesheets/*'
inside ('public/stylesheets') do
  run "mkdir blueprint; touch base.css"
  run 'curl -L  http://github.com/joshuaclayton/blueprint-css/raw/master/blueprint/ie.css > blueprint/ie.css'
  run 'curl -L  http://github.com/joshuaclayton/blueprint-css/raw/master/blueprint/screen.css > blueprint/screen.css'
  run 'curl -L  http://github.com/joshuaclayton/blueprint-css/raw/master/blueprint/print.css > blueprint/print.css'
end

file 'app/helpers/application_helper.rb',
%q{module ApplicationHelper
  def body_class
   "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end
end
}

file 'app/views/shared/_flashes.html.erb',
%q{<div id="flash">
  <% flash.each do |key, value| -%>
    <div id="flash_<%= key %>"><%=h value %></div>
  <% end -%>
</div>
}


file 'app/views/layouts/application.html.erb',
%{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <title>#{project_dir}</title>
    
    <%= stylesheet_link_tag 'blueprint/screen', :media => 'screen, projection', :cache => true %>
    <%= stylesheet_link_tag 'blueprint/print', :media => 'print', :cache => true %>
    <!--[if IE]><%= stylesheet_link_tag 'blueprint/ie', :media => 'screen, projection', :cache => true %><![endif]-->
    <%= stylesheet_link_tag :all, :cache => true %>
    <%= javascript_include_tag :defaults %>
  </head>
  <body class="<%= body_class %>">
  
    <%= render :partial => 'shared/flashes' -%>
    <%= yield %>
    
  </body>
</html>
}




run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"

git :add => "."
git :commit => "-m 'initial commit'"


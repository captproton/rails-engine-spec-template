say(message = "🙏 Installing rspec, capybara, factory_bot, ffaker...", color = :magenta) 

# Add test files
inject_into_file GEMSPEC_FILE, after: /spec\.files.*$/ do 
  %{\n  spec.test_files = Dir["spec/**/*"]}
end

# Add the gems
inject_into_file GEMSPEC_FILE, before: %r{^end$} do
%{
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'ffaker'
}
end

bundle

generate 'rspec:install'

# Setting default Rake task to :spec
append_to_file 'Rakefile' do 
%{
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')
task :default => :spec
}.strip
end

# Setting rspec and factory_bot as default generators...
insert_into_file "lib/#{name}/engine.rb", after: /isolate_namespace .*$/ do
%{

    config.generators do |g|
      g.test_framework :rspec, fixtures: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.assets false
      g.helper false
    end
}
end

# Setting up spec helper for engines...

# RSpec doesn't understand engine dummy path, fix that.
gsub_file 'spec/rails_helper.rb', '../config/environment', '../dummy/config/environment.rb'

# FIX
# Rspec defaults to Rails.root but that's spec/dummy...
# gsub_file 'spec/spec_helper.rb', 'Rails.root.join("spec/support/**/*.rb")', '"#{File.dirname(__FILE__)}/support/**/*.rb"'
insert_into_file 'spec/spec_helper.rb', before: /^RSpec\.configure/ do 
%{
  
require File.expand_path("../dummy/config/environment.rb", __FILE__)
}
end

# FIX

# Require factory_bot
# insert_into_file 'spec/spec_helper.rb', "\nrequire 'factory_bot_rails'", after: "require 'rspec/autorun'" 

insert_into_file 'spec/spec_helper.rb', before: /^RSpec\.configure/ do 
%{
require 'rspec/rails'
require 'factory_bot_rails'

}
end

# Add Factory Bot methods to RSpec, and include the route's url_helpers.
insert_into_file 'spec/spec_helper.rb', before: /^end$/ do 
%{
  config.include FactoryBot::Syntax::Methods
  config.include #{camelized}::Engine.routes.url_helpers
}
end

git_commit "Installed rspec"
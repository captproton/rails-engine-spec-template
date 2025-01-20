intro_message = "🙏 Installing minimal RSpec setup for engine verification..."
say(intro_message, :magenta)

# Add test files to gemspec
inject_into_file GEMSPEC_FILE, after: /spec\.files.*$/ do
  %{\n  spec.test_files = Dir["spec/**/*"]}
end

# Add essential test dependencies
inject_into_file GEMSPEC_FILE, before: %r{^end$} do
%{
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'capybara'
}
end

bundle

generate 'rspec:install'

# Set up Rake tasks
append_to_file 'Rakefile' do
%{
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')
task :default => :spec
}.strip
end

# Configure generators
insert_into_file "lib/#{name}/engine.rb", after: /isolate_namespace .*$/ do
%{

    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end
}
end

# Create streamlined rails_helper
remove_file "spec/rails_helper.rb"
create_file "spec/rails_helper.rb" do
<<-HELPER
require 'spec_helper'
require File.expand_path('../dummy/config/environment', __FILE__)
require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
HELPER
end

# Create minimal core engine verification spec
create_file "spec/#{name}_spec.rb" do
<<-SPEC
require 'rails_helper'

RSpec.describe #{camelized} do
  it "is a module" do
    expect(described_class).to be_const_defined
  end

  it "has a version number" do
    expect(#{camelized}::VERSION).not_to be_nil
  end
end

RSpec.describe #{camelized}::Engine do
  it "is an engine" do
    expect(described_class.superclass).to eq(Rails::Engine)
  end

  it "isolates its namespace" do
    expect(described_class.isolated?).to be true
  end
end
SPEC
end

# Create basic controller spec
create_file "spec/controllers/#{name}/application_controller_spec.rb" do
<<-SPEC
require 'rails_helper'

RSpec.describe #{camelized}::ApplicationController, type: :controller do
  it "is a subclass of ActionController::Base" do
    expect(described_class.superclass).to eq(ActionController::Base)
  end

  it "uses the engine's layout" do
    expect(described_class._layout).to eq("#{name}/application")
  end
end
SPEC
end

# Add documentation to README
append_to_file "README.md" do
<<-README

## Initial Testing
The engine comes with minimal verification specs to ensure proper setup:

1. Core specs (`spec/#{name}_spec.rb`):
   - Verify engine module and version
   - Confirm engine configuration
   - Check namespace isolation

2. Controller specs:
   - Verify base controller configuration
   - Confirm layout setup

To run the verification suite:
```
bundle exec rspec
```

### Adding Your Tests
- Model specs go in `spec/models/#{name}/`
- Controller specs go in `spec/controllers/#{name}/`
- Feature specs go in `spec/features/`
- Shared code goes in `spec/support/`

### Next Steps
After verifying the initial setup:
1. Add model specs for your domain models
2. Create controller specs for new endpoints
3. Write feature specs for user flows
4. Set up shared examples and contexts
README
end

# Create demo route spec
create_file "spec/routing/#{name}/demo_route_spec.rb" do
<<-SPEC
require 'rails_helper'

RSpec.describe 'Demo route', type: :routing do
  routes { #{camelized}::Engine.routes }

  it 'routes to the demo page' do
    expect(get: '/dummy_rails7_testing/index').to be_routable
  end
end
SPEC
end

git_commit "Streamline initial RSpec setup with minimal verification specs"

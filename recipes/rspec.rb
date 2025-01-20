intro_message = "🙏 Installing minimal RSpec setup for engine verification..."
say(message = intro_message, color: :magenta)

# Add test files
inject_into_file GEMSPEC_FILE, after: /spec\.files.*$/ do
  %{\n  spec.test_files = Dir["spec/**/*"]}
end

# Add essential dependencies
inject_into_file GEMSPEC_FILE, before: %r{^end$} do
%{
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'capybara'
}
end

bundle

generate 'rspec:install'

# Setting default Rake task to :spec
append_to_file 'Rakefile' do
%{
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')
task :default => :spec
}.strip
end

# Minimal generator configuration
insert_into_file "lib/#{name}/engine.rb", after: /isolate_namespace .*$/ do
%{

    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end
}
end

# Create minimal rails_helper
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

# Create core engine verification spec
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

  it "is properly mounted in dummy app" do
    expect(Rails.application.routes.named_routes.names).to include(:#{name})
  end
end
SPEC
end

# Create application controller spec
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

# Create example feature spec
create_file "spec/features/example_spec.rb" do
<<-SPEC
require 'rails_helper'

RSpec.describe "Example Feature", type: :feature do
  it "has a working dummy app" do
    visit #{name}.root_path
    expect(page.status_code).to eq(200)
  end
end
SPEC
end

# Update README with testing information
append_to_file "README.md" do
<<-README

## Initial Testing
The engine comes with minimal verification specs to ensure proper setup:

1. Core specs (`spec/#{name}_spec.rb`):
   - Verify engine module and version
   - Confirm proper engine mounting
   - Check namespace isolation

2. Controller specs:
   - Verify base controller configuration
   - Check routing setup

3. Feature specs:
   - Ensure dummy app is working
   - Template for adding new features

To run the verification suite:
```
bundle exec rspec
```

### Adding New Tests
- Place model specs in `spec/models/#{name}/`
- Controller specs go in `spec/controllers/#{name}/`
- Feature specs belong in `spec/features/`
- Add shared examples in `spec/support/`

### Next Steps
After verifying the initial setup, you can:
1. Add model specs for your domain models
2. Create controller specs for new endpoints
3. Write feature specs for user flows
4. Set up shared examples and contexts
README
end

git_commit "Streamline initial RSpec setup with minimal verification specs"
# template.rb
# frozen_string_literal: true

require_relative 'lib/documentation_system/registry'
require_relative 'lib/documentation_system/section'
require_relative 'lib/documentation_system/readme_template'

def git_commit(message)
  curdir = Dir.getwd
  say "$$ gem root directory is: #{destination_root}"
  Dir.chdir destination_root
  git add: '.'
  git commit: "-m '#{message}' -q"
end

def bundle
  run "bundle install --quiet"
end

GEMSPEC_FILE = File.join(destination_root, "#{name}.gemspec")
RECIPE_PATH = File.join(File.dirname(rails_template), "recipes")
RECIPES = %w{
  customize_meta
  dummy_app
  rspec
  guard
  developer_gems
  rails7_gems
  tailwind_ui
  setup_overmind
}

# Clear any existing documentation
DocumentationSystem::Registry.clear

# Apply recipes
RECIPES.each do |recipe|
  recipe_file = File.join(RECIPE_PATH, "#{recipe}.rb")
  say "Applying recipe: #{recipe}", :green
  apply recipe_file
end

# Generate README
# readme_content = DocumentationSystem::ReadmeTemplate.new(name)
#   .render(DocumentationSystem::Registry.instance)
# create_file "README.md", readme_content

say "Garbage collecting git...", :blue
git gc: '--quiet'

say %{
  Things to do:
  - rake db:migrate
  - Start development server with: cd spec/dummy && bin/dev

  Visit http://localhost:3000/dummy_rails7_testing/index for component demos
}, :green

say "\n🎉 Engine created successfully!", :green

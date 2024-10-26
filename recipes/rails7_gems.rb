intro_message = "🙏 Installing Rails 7 dependencies (jsbundling, stimulus, turbo)..."
say(message = intro_message, color: :magenta)

# Register documentation
# #{name.camelize}::RecipeDocumentation.register_recipe_docs('rails7_gems') do
#   DocumentationSystem::Registry.register(
#     :features,
#     [
#       "🚀 Built for Rails 7",
#       "⚡️ Modern frontend with import maps",
#       "🔄 Hotwire (Turbo & Stimulus)"
#     ]
#   )
# end

# Add dependencies
inject_into_file GEMSPEC_FILE, before: %r{^end$} do
%{
  spec.add_dependency 'jsbundling-rails'
  spec.add_dependency 'stimulus-rails'
  spec.add_dependency 'turbo-rails'
}
end
bundle

# Set up application directory
app_dir = "#{destination_root}/spec/dummy"
Dir.chdir app_dir
FileUtils.touch "#{app_dir}/Gemfile"

# Install esbuild
step_message = "🧩 Installing esbuild..."
say(message = step_message)
Dir.chdir destination_root
system("bundle add jsbundling-rails")
bundle
Dir.chdir app_dir
system("rails javascript:install:esbuild")
Dir.chdir destination_root

# Install Stimulus
step_message = "🧩 Installing stimulus..."
say(message = step_message)
Dir.chdir destination_root
system("bundle add stimulus-rails")
bundle
Dir.chdir app_dir
system("rails stimulus:install")
Dir.chdir destination_root

# Install Turbo
step_message = "🧩 Installing turbo..."
say(message = step_message)
Dir.chdir destination_root
system("bundle add turbo-rails")
bundle
Dir.chdir app_dir
system("rails turbo:install")
system("rails turbo:install:redis")
Dir.chdir destination_root

# Create test controller
step_message = "🧩 Creating test controller..."
say(message = step_message)
Dir.chdir app_dir
run "rails g controller DummyRails7Testing index"
Dir.chdir destination_root

git_commit "Add Rails 7 dependencies"

# recipes/guard.rb
intro_message = "🙏 Installing guard..."
say(message = intro_message, color: :magenta)

# Register documentation
# #{name.camelize}::DocumentationHelper.register_doc_section(
#   :features,
#   ["👀 Live test and development reloading"]
# )

# #{name.camelize}::DocumentationHelper.register_doc_section(
#   :guard,
#   {
#     title: "Guard Integration",
#     content: <<~MD
#       ### Automated Testing and Reloading
#       This engine uses Guard for automated test running and Rails reloading:

#       ```bash
#       # Start Guard
#       bundle exec guard
#       ```

#       Guard will:
#       - Run relevant specs when files change
#       - Reload Rails when necessary
#       - Provide immediate feedback during development
#     MD
#   },
#   position: :after_development
# )

inject_into_file GEMSPEC_FILE, before: %r{^end$} do
%{
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rails'
}
end

bundle

run 'bundle exec guard init'

git_commit "Installed guard"

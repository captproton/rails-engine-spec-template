# recipes/developer_gems.rb
intro_message = "🙏 Installing development gems..."
say(intro_message, :magenta)

# Register documentation
# #{name.camelize}::DocumentationHelper.register_doc_section(
#   :features,
#   ["🛠️ Comprehensive development tools"]
# )

# #{name.camelize}::DocumentationHelper.register_doc_section(
#   :development_tools,
#   {
#     title: "Development Tools",
#     content: <<~MD
#       ### Included Development Gems
#       The engine comes with several helpful development gems:
#       - Puma - Modern web server
#       - Pry (pry-doc, pry-rails) - Enhanced debugging
#       - awesome_print - Improved object formatting
#       - binding_of_caller - Advanced debugging features
#     MD
#   },
#   position: :after_development
# )

inject_into_file GEMSPEC_FILE, before: %r{^end$} do
  %{
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'pry-rails'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'binding_of_caller'
}
end

bundle

git_commit "Adding development gems"

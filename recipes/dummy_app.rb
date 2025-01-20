# recipes/dummy_app.rb
intro_message = "🙏` Dummy app adjustments for a` rails engine"
say(intro_message, :magenta)

# Register documentation
# #{name.camelize}::DocumentationHelper.register_doc_section(
#   :features,
#   ["🔬 Integrated test application"]
# )

# #{name.camelize}::DocumentationHelper.register_doc_section(
#   :dummy_app,
#   {
#     title: "Test Application",
#     content: <<~MD
#       ### Dummy Application
#       The engine includes a fully functional test application in `spec/dummy`.
#       This application demonstrates engine features and provides a development environment.

#       #### Structure
#       ```
#       spec/dummy/
#       ├── app/
#       ├── config/
#       ├── db/
#       └── public/
#       ```

#       #### Database
#       The test application uses SQLite by default. Generated files are git-ignored:
#       - Database files (sqlite3)
#       - Log files
#       - Temporary files
#       - Sass cache
#     MD
#   },
#   position: :after_development
# )

if File.exist?(File.join(destination_root, 'spec', 'dummy'))
  say "Spec dummy application already exists, skipping."
else

  say "Installing engine dummy app"
  # 1. create_dummy_app command changes working directory booooooooo
  # 2. inside() reports a warning, boooooooo
  curdir = Dir.getwd
  say "Current directory is #{curdir}"
  create_dummy_app 'spec/dummy'
  # get back to the original directory
  Dir.chdir curdir

  append_to_file '.gitignore' do
"spec/dummy/db/*.sqlite3
spec/dummy/db/*.sqlite3-journal
spec/dummy/log/*.log
spec/dummy/tmp/
spec/dummy/.sass-cache"
  end

  git_commit "Set up dummy app in spec folder."
end

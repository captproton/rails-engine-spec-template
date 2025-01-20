# recipes/customize_meta.rb
intro_message = "
  🙏 Setting up
  LET US ADD OUR META DATA:
    - engine name
    - homepage
    - Summary of engine name
    - Description of engine name
    - source_code_uri
    - changelog_uri
"
say(intro_message, :magenta)

# Register documentation
# "#{name.camelize}::DocumentationHelper".constantize.register_doc_section(
#   :features,
#   ["📝 Customizable meta information"]
# )

# {name.camelize}::DocumentationHelper.register_doc_section(
#   :configuration,
#   {
#     title: "Meta Configuration",
#     content: <<~MD
#       ### Meta Information
#       This engine includes configurable meta information:
#       - Engine name
#       - Homepage URL
#       - Summary
#       - Description
#       - Source code URI
#       - Changelog URI

#       These are configured during the engine setup process.
#     MD
#   },
#   position: :after_installation
# )


# setup
# puts "🙏 Setting up"
meta_message = "Let's update the gemspec to remove the bundler warnings:
    - rake db:migrate
\n"
say(meta_message, :magenta)
new_engine_name = ask("engine name: ", :magenta)
new_homepage_url = ask("homepage url: ", :magenta)
new_summary = ask("Summary: ", :magenta)
new_description = ask("Description: ", :magenta)
new_source_code_uri = ask("Your gem's public repo URL: ", :magenta)
new_changelog_uri = "#{new_source_code_uri}/blob/main/CHANGELOG.md"

# spec.homepage
gsub_file "#{new_engine_name}.gemspec", /spec\.homepage    \= \"TODO\"/, "spec.homepage    = \"#{new_homepage_url}\""

# spec.summary
gsub_file "#{new_engine_name}.gemspec", /\"TODO: Summary of.*\"/, "\"#{new_summary}\" "

# spec.description
gsub_file "#{new_engine_name}.gemspec",  /\"TODO: Description of.*\"/, "\"#{new_description}\""

# spec.gemserver (double quotes means that we are deleting it for the
# default)
gsub_file "#{new_engine_name}.gemspec", /spec.metadata\[\"allowed_push_host\"\] = \"TODO: Set to \'http\:\/\/mygemserver\.com\'\"/, ""

# spec.metadata["source_code_uri"]
gsub_file "#{new_engine_name}.gemspec", /spec.metadata\[\"source_code_uri\"\] = \"TODO: Put your gem's public repo URL here.\"/, "spec.metadata\[\"source_code_uri\"\] = \"#{new_source_code_uri}\""

#   spec.metadata["changelog_uri"]
gsub_file "#{new_engine_name}.gemspec", /spec.metadata\[\"changelog_uri\"\] = \"TODO: Put your gem's CHANGELOG.md URL here.\"/, "spec.metadata\[\"changelog_uri\"\] = \"#{new_changelog_uri}\""

git_commit "Customizing meta of gem"
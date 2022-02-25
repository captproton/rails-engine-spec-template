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
say(message = intro_message, color = :magenta) 

# setup
# puts "🙏 Setting up"
meta_message = "Let's update the gemspec to remove the bundler warnings:
    - rake db:migrate
 \n"
say(message = meta_message, color = :magenta) 
new_engine_name = ask("engine name: ", color = :magenta)
new_homepage_url = ask("homepage url: ", color = :magenta)
new_summary = ask("Summary: ", color = :magenta)
new_description = ask("Description: ", color = :magenta)
new_source_code_uri = ask("Your gem's public repo URL: ", color = :magenta)
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
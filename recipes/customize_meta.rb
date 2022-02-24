say %{
  🙏 Setting up
  LET US ADD OUR META DATA:
    - engine name
    - homepage
    - Summary of engine name
    - Description of engine name
    - source_code_uri
    - changelog_uri
}

# setup
# puts "🙏 Setting up"
say %{
  Let's update the gemspec to remove the bundler warnings:
    - edit #{name}.gemspec to set correct info and remove bundler warnings.
    - rake db:migrate
}
gsub_file 'engine_name.gemspec', /spec\.homepage    \= \"TODO\"/, "spec.homepage    = \"https://github.com\""
gsub_file 'engine_name.gemspec', /TODO\: Summary of /, "Summary of "
gsub_file 'engine_name.gemspec', /TODO\: Description of /, "Description of "
gsub_file 'engine_name.gemspec', /spec.metadata\[\"allowed_push_host\"\] = \"TODO: Set to \'http\:\/\/mygemserver\.com\'\"/, ""
gsub_file 'engine_name.gemspec', /spec.metadata\[\"source_code_uri\"\] = \"TODO: Put your gem's public repo URL here.\"/, "spec.metadata\[\"source_code_uri\"\] = spec.homepage"
gsub_file 'engine_name.gemspec', /spec.metadata\[\"changelog_uri\"\] = \"TODO: Put your gem's CHANGELOG.md URL here.\"/, "spec.metadata\[\"changelog_uri\"\] = spec.homepage"

# Rspec... if you _insist_
# puts "🙏 Starting off with RSpec!"
# run "rails app:template LOCATION='https://railsbytes.com/script/x7msNE'"


# FactoryBot
# puts "🙏 Moving on to install FactoryBot!"
# run "rails app:template LOCATION='https://railsbytes.com/script/XnJsbX'"

# StandardRB
#puts "🙏 Moving on to install StandardRB!"
# run "rails app:template LOCATION='https://railsbytes.com/script/xjNs4x'"
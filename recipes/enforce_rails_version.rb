# Remove any existing Rails dependency line before adding our own
gsub_file "#{destination_root}/#{name}.gemspec", /^.*spec\.add_dependency.*(["'])rails\1.*$\n/, ''
gsub_file "#{destination_root}/#{name}.gemspec", /^.*spec\.add_runtime_dependency.*(["'])rails\1.*$\n/, ''

# Add Rails 7 dependency
inject_into_file GEMSPEC_FILE, after: "Gem::Specification.new do |spec|\n" do
  %{  spec.add_dependency "rails", "~> 7.1"  # Enforce Rails 7\n}
end

# Update dummy app's Gemfile
dummy_gemfile = "#{destination_root}/spec/dummy/Gemfile"
if File.exist?(dummy_gemfile)
  # Remove any existing Rails gem lines
  gsub_file dummy_gemfile, /^.*gem.*(['"])rails\1.*$\n/, ''
  
  # Add Rails 7 requirement
  inject_into_file dummy_gemfile, after: "source 'https://rubygems.org'\n" do
    %{gem "rails", "~> 7.1"  # Enforce Rails 7\n}
  end
end

git_commit "Enforce Rails 7 version"
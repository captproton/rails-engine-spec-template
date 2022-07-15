intro_message = "🙏 Installing guard..."
say(message = intro_message, color = :magenta) 

inject_into_file GEMSPEC_FILE, before: %r{^end$} do
%{
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rails'
}
end

bundle

run 'bundle exec guard init'

git_commit "Installed guard"
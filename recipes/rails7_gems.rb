intro_message = "🙏 Installing jsbundling, cssbundling, stimulus, and turbo..."
say(message = intro_message, color = :magenta) 

inject_into_file GEMSPEC_FILE, before: %r{^end$} do 
  %{
  spec.add_dependency 'jsbundling-rails'
  spec.add_dependency 'cssbundling-rails'
  spec.add_dependency 'stimulus-rails'
  spec.add_dependency 'turbo-rails'
}
end

bundle

# git_commit "Adding development gems"
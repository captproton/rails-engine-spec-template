intro_message = "🙏 Installing thin, pry, awesome_print..."
say(message = intro_message, color = :magenta) 

inject_into_file GEMSPEC_FILE, before: %r{^end$} do 
  %{
  spec.add_development_dependency 'thin'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'pry-rails'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'binding_of_caller'
}
end

bundle

# git_commit "Adding development gems"
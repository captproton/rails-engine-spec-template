
def git_commit(message)
  git add: '.'
  git commit: "-m '#{message}' -q"
end

def bundle
  run "bundle install --quiet"
end

say "Creating git repository..."
git :init
git_commit "Initial commit of empty Rails engine."

GEMSPEC_FILE = File.join(destination_root, "#{name}.gemspec")
RECIPE_PATH = File.join(File.dirname(rails_template), "recipes")
RECIPES = %w{customize_meta dummy_app rspec guard developer_gems}

RECIPES.each do |recipe|
  apply File.join(RECIPE_PATH, "#{recipe}.rb")
end

say "Garbage collecting git..."
git gc: '--quiet'

say %{
  Things to do:
    - rake db:migrate
}
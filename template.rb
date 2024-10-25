# template.rb
def git_commit(message)
  #usually happens during a recipe
  curdir = Dir.getwd
  # keep line below for debugging later
  # say "*$* Current directory is #{curdir}"

  # get back to the gem's root directory
  say "*$$ gem root directory is: #{destination_root}"
  Dir.chdir destination_root
  # keep lines below for debugging later
  # curdir = Dir.getwd
  # say "*$% Current directory is #{curdir}"

  git add: '.'
  git commit: "-m '#{message}' -q"
end

def bundle
  run "bundle install --quiet"
end


GEMSPEC_FILE = File.join(destination_root, "#{name}.gemspec")
RECIPE_PATH = File.join(File.dirname(rails_template), "recipes")
RECIPES = %w{customize_meta dummy_app rspec guard developer_gems rails7_gems}

RECIPES.each do |recipe|
  apply File.join(RECIPE_PATH, "#{recipe}.rb")
end

say "Garbage collecting git..."
git gc: '--quiet'

say %{
  Things to do:
    - rake db:migrate
}

# recipes/rails7_gems.rb
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

# change into the rails root directory
app_dir = "#{destination_root}/spec/dummy"
Dir.chdir app_dir
# We need Gemfile for to add Redis
FileUtils.touch "#{app_dir}/Gemfile"

# =================================================================
step_message = "🧩 Installing esbuild..."
say(message = step_message)
Dir.chdir destination_root
system("bundle add jsbundling-rails")
bundle
Dir.chdir app_dir
system("rails javascript:install:esbuild")
Dir.chdir destination_root


# =================================================================
step_message = "🧩 Installing bootstrap..."
say(message = step_message)
Dir.chdir destination_root
system("bundle add cssbundling-rails")
bundle
Dir.chdir app_dir
system("rails css:install:bootstrap")
Dir.chdir destination_root

# =================================================================
step_message = "🧩 Installing stimulus..."
say(message = step_message)
Dir.chdir destination_root
system("bundle add stimulus-rails")
bundle
Dir.chdir app_dir
system("rails stimulus:install")
Dir.chdir destination_root


# =================================================================
step_message = "🧩 Installing turbo..."
say(message = step_message)
Dir.chdir destination_root
system("bundle add turbo-rails")
bundle
Dir.chdir app_dir
system("rails turbo:install")
system("rails turbo:install:redis")
Dir.chdir destination_root

# =================================================================
step_message = "🧩 Creating test page for stimulus and turbo..."
say(message = step_message)
Dir.chdir app_dir
puts "$*$> rails g controller DummyRails7Testing index"
run "rails g controller DummyRails7Testing index"

Dir.chdir destination_root
append_to_file 'spec/dummy/app/views/dummy_rails7_testing/index.html.erb' do
 '<h2>You should see hello world below</h2>
  <div data-controller="hello">
  </div>
  <p>If you see "Hello World!" above, Stimulus.js is working. </p>'
end

Dir.chdir destination_root

# =================================================================
# change back to the gem root directory
Dir.chdir destination_root


# * install esbuild (<https://www.youtube.com/watch?v=qOptalp8zUY>)
#   * install jsbundling-rails
#     * bundle add jsbundling-rails
#     * bundle install
#     * cd spec/dummy
#     * rails javascript:install:esbuild
#     * cd ../../
#   *
# * install cssbundling
#   * bundle add cssbundling-rails (at gem root)
#   * bundle install
#   * cd spec/dummy
#   * rails css:install:bootstrap

# * install hotwire (https://www.youtube.com/watch?v=Qp6sxgjA-xY&t=745s)
#   * stimulus
#     * bundle add  stimulus-rails (at gem root)
#     * bundle install
#     * cd spec/dummy
#     * rails stimulus:install
#   * turbo
#     * bundle add turbo-rails (at gem root)
#     * bundle install
#     * cd spec/dummy
#     * rails turbo:install
#     * rails turbo:install:redis


git_commit "Adding rails 7 gems"

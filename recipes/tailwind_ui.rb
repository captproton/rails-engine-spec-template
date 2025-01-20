intro_message = "🎨 Installing Tailwind UI..."
say(intro_message, :magenta)

# Add Tailwind dependency
inject_into_file GEMSPEC_FILE, before: %r{^end$} do
%{
  spec.add_dependency 'tailwindcss-rails'
}
end
bundle

app_dir = "#{destination_root}/spec/dummy"

# Install Tailwind
step_message = "🧩 Installing Tailwind..."
say(step_message)
Dir.chdir destination_root
system("bundle add tailwindcss-rails")
bundle
Dir.chdir app_dir
system("rails tailwindcss:install")

# Update Tailwind config to include engine paths
inject_into_file "#{app_dir}/config/tailwind.config.js", 
  after: "content: [" do
  "\n    // Engine paths\n" +
  "    '../../app/views/**/*',\n" +
  "    '../../app/helpers/**/*.rb',\n" +
  "    '../../app/javascript/**/*.js',\n"
end

# Update application.tailwind.css to import engine styles
append_to_file "#{app_dir}/app/assets/stylesheets/application.tailwind.css" do
  "\n/* Engine stylesheet */\n@import \"../../../../app/assets/stylesheets/#{name}/application\";\n"
end

# Update asset configuration to include engine assets
inject_into_file "#{app_dir}/config/initializers/assets.rb",
  after: "Rails.application.config.assets.paths << Rails.root.join(\"node_modules\")\n" do
  "\n# Add engine assets path\nRails.application.config.assets.paths << Rails.root.join('../../app/assets/stylesheets')\n"
end

# Update the demo view with Tailwind styles
gsub_file "#{app_dir}/app/views/dummy_rails7_testing/index.html.erb", 
  /<h1>.*<\/h1>.*$/m do
  <<~ERB
    <div class="min-h-screen bg-gray-100 p-6">
      <div class="bg-white rounded-lg shadow p-6 max-w-lg mx-auto">
        <h1 class="text-2xl font-bold mb-4">Rails Engine with Tailwind CSS</h1>
        <p class="text-gray-600">If you're seeing this styled properly, Tailwind CSS is working!</p>
        <div class="mt-4">
          <button class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
            Test Button
          </button>
        </div>
      </div>
    </div>
  ERB
end

git_commit "Add Tailwind CSS with engine configuration"
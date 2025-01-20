intro_message = "🎨 Installing Tailwind UI..."
say(intro_message, :magenta)

# Add Tailwind dependency
inject_into_file GEMSPEC_FILE, before: %r{^end$} do
%{
  spec.add_dependency 'tailwindcss-rails'
  spec.add_dependency 'cssbundling-rails'
}
end
bundle

app_dir = "#{destination_root}/spec/dummy"

# Install Tailwind
step_message = "🧩 Installing Tailwind..."
say(step_message)
Dir.chdir destination_root
system("bundle add tailwindcss-rails cssbundling-rails")
bundle
Dir.chdir app_dir
system("rails tailwindcss:install")

# Create Tailwind config
create_file "#{app_dir}/config/tailwind.config.js", <<~JS
  const defaultTheme = require('tailwindcss/defaultTheme')

  module.exports = {
    content: [
      // Include engine views and components
      '../../app/views/**/*.{erb,haml,html,slim}',
      '../../app/components/**/*.{erb,haml,html,slim}',
      '../../app/helpers/**/*.rb',
      '../../app/javascript/**/*.js',
      // Include dummy app files
      './public/*.html',
      './app/helpers/**/*.rb',
      './app/javascript/**/*.js',
      './app/views/**/*.{erb,haml,html,slim}'
    ],
    theme: {
      extend: {
        fontFamily: {
          sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        },
      },
    },
    plugins: [
      require('@tailwindcss/forms'),
      require('@tailwindcss/aspect-ratio'),
      require('@tailwindcss/typography'),
    ],
  }
JS

# Add Inter font to application layout
inject_into_file "#{app_dir}/app/views/layouts/application.html.erb",
  after: "<head>\n" do
  "    <link rel=\"stylesheet\" href=\"https://rsms.me/inter/inter.css\">\n"
end

# Ensure Tailwind is imported in application.tailwind.css
create_file "#{app_dir}/app/assets/stylesheets/application.tailwind.css", <<~CSS
  @tailwind base;
  @tailwind components;
  @tailwind utilities;

  /* Engine styles */
  @import "../../../../app/assets/stylesheets/#{name}/application";
CSS

# Create engine stylesheet
create_file "app/assets/stylesheets/#{name}/application.css", <<~CSS
  /* Engine-specific styles */
  @layer components {
    /* Add your custom components here */
  }
CSS

# Update asset configuration
create_file "#{app_dir}/config/initializers/assets.rb", <<~RUBY
  # Be sure to restart your server when you modify this file.

  # Version of your assets, change this if you want to expire all your assets.
  Rails.application.config.assets.version = "1.0"

  # Add additional assets to the asset load path.
  Rails.application.config.assets.paths << Rails.root.join("node_modules")

  # Add engine assets path
  Rails.application.config.assets.paths << Rails.root.join('../../app/assets/stylesheets')

  # Precompile additional assets.
  Rails.application.config.assets.precompile += %w( application.tailwind.css #{name}/application.css )
RUBY

# Update package.json build scripts
inject_into_file "#{app_dir}/package.json", after: %r{"scripts": \{} do
  %{
    "build:css": "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify",
    "watch:css": "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --watch"
  }
end

# Update Procfile.dev
append_to_file "#{app_dir}/Procfile.dev" do
  "css: bin/rails tailwindcss:watch\n"
end

# Create development setup script
create_file "#{app_dir}/bin/dev", <<~SH
  #!/usr/bin/env sh

  if ! gem list foreman -i --silent; then
    echo "Installing foreman..."
    gem install foreman
  fi

  # Default to port 3000 if not specified
  export PORT="${PORT:-3000}"

  exec foreman start -f Procfile.dev "$@"
SH

chmod "#{app_dir}/bin/dev", 0755

# Install Tailwind UI specific dependencies
Dir.chdir app_dir
system("yarn add @tailwindcss/forms @tailwindcss/aspect-ratio @tailwindcss/typography @headlessui/react @heroicons/react")
system("yarn install")
Dir.chdir destination_root

# Create basic components for testing
create_file "#{app_dir}/app/views/dummy_rails7_testing/index.html.erb", <<~ERB
  <div class="min-h-screen bg-gray-100 py-6 flex flex-col justify-center sm:py-12">
    <div class="relative py-3 sm:max-w-xl sm:mx-auto">
      <div class="relative px-4 py-10 bg-white shadow-lg sm:rounded-3xl sm:p-20">
        <div class="max-w-md mx-auto">
          <div class="divide-y divide-gray-200">
            <div class="py-8 text-base leading-6 space-y-4 text-gray-700 sm:text-lg sm:leading-7">
              <p class="text-2xl font-bold mb-8">Rails Engine with Tailwind CSS</p>
              <p>If you're seeing this styled properly, Tailwind CSS is working!</p>
              <div class="mt-8">
                <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                  Test Button
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
ERB

# Add setup instructions to README
append_to_file "README.md" do
  <<~MD

    ## Development

    To start the development environment:

    1. cd spec/dummy
    2. bin/dev

    This will start the Rails server and Tailwind CSS watcher.
  MD
end

git_commit "Add Tailwind UI components and styling"
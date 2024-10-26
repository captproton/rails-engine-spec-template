intro_message = "🎨 Installing Tailwind UI..."
say(message = intro_message, color: :magenta)

# Register documentation
# #{name.camelize}::RecipeDocumentation.register_recipe_docs('tailwind_ui') do
#   DocumentationSystem::Registry.register(
#     :features,
#     [
#       "🎨 Styled with Tailwind UI",
#       "📱 Responsive component library"
#     ]
#   )
# end

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
say(message = step_message)
Dir.chdir destination_root
system("bundle add tailwindcss-rails")
bundle
Dir.chdir app_dir
system("rails tailwindcss:install")

# Create Tailwind config
append_to_file "#{app_dir}/config/tailwind.config.js" do
%{
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
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
}
end

# Add Inter font to application layout
inject_into_file "#{app_dir}/app/views/layouts/application.html.erb",
  after: "<head>\n" do
  "    <link rel=\"stylesheet\" href=\"https://rsms.me/inter/inter.css\">\n"
end

# Ensure Tailwind is imported in application.tailwind.css
create_file "#{app_dir}/app/assets/stylesheets/application.tailwind.css" do
%{@tailwind base;
@tailwind components;
@tailwind utilities;
}
end

# Update asset configuration
append_to_file "#{app_dir}/config/initializers/assets.rb" do
%{
Rails.application.config.assets.paths << Rails.root.join("node_modules")
Rails.application.config.assets.precompile += %w( application.tailwind.css )
}
end

# Create test page with Tailwind UI components
append_to_file 'spec/dummy/app/views/dummy_rails7_testing/index.html.erb' do
%{<div class="min-h-screen bg-gray-100">
  <!-- Navigation -->
  <nav class="bg-white shadow">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between h-16">
        <div class="flex">
          <div class="flex-shrink-0 flex items-center">
            <h1 class="text-xl font-bold text-gray-800">Rails Engine Demo</h1>
          </div>
        </div>
      </div>
    </div>
  </nav>

  <!-- Main Content -->
  <div class="py-10">
    <header>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 class="text-3xl font-bold leading-tight text-gray-900">
          Testing Rails 7 Features with Tailwind UI
        </h2>
      </div>
    </header>
    <main>
      <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
        <!-- Feature Section -->
        <div class="bg-white overflow-hidden shadow rounded-lg divide-y divide-gray-200 mt-8">
          <!-- Stimulus Test -->
          <div class="px-4 py-5 sm:p-6">
            <div class="bg-white px-4 py-5 border-b border-gray-200 sm:px-6">
              <h3 class="text-lg leading-6 font-medium text-gray-900">
                Stimulus Test
              </h3>
            </div>
            <div class="px-4 py-5 sm:p-6">
              <div data-controller="hello">
              </div>
              <p class="mt-2 text-sm text-gray-500">
                If you see "Hello World!" above, Stimulus.js is working.
              </p>
            </div>
          </div>

          <!-- Alert Component -->
          <div class="px-4 py-5 sm:p-6">
            <div class="rounded-md bg-green-50 p-4">
              <div class="flex">
                <div class="flex-shrink-0">
                  <!-- Heroicon check-circle -->
                  <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                </div>
                <div class="ml-3">
                  <p class="text-sm font-medium text-green-800">
                    Tailwind UI is working if this alert is styled correctly!
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- Button Examples -->
          <div class="px-4 py-5 sm:p-6">
            <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mr-2">
              Primary
            </button>
            <button class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded mr-2">
              Secondary
            </button>
            <button class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded">
              Tertiary
            </button>
          </div>

          <!-- Card Grid -->
          <div class="px-4 py-5 sm:p-6">
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              <div class="bg-white overflow-hidden shadow rounded-lg">
                <div class="px-4 py-5 sm:p-6">
                  <h3 class="text-lg font-medium text-gray-900">Card 1</h3>
                  <p class="mt-2 text-sm text-gray-500">Content</p>
                </div>
              </div>
              <div class="bg-white overflow-hidden shadow rounded-lg">
                <div class="px-4 py-5 sm:p-6">
                  <h3 class="text-lg font-medium text-gray-900">Card 2</h3>
                  <p class="mt-2 text-sm text-gray-500">Content</p>
                </div>
              </div>
              <div class="bg-white overflow-hidden shadow rounded-lg">
                <div class="px-4 py-5 sm:p-6">
                  <h3 class="text-lg font-medium text-gray-900">Card 3</h3>
                  <p class="mt-2 text-sm text-gray-500">Content</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</div>}
end

# Install Tailwind UI specific dependencies
Dir.chdir app_dir
system("yarn add @tailwindcss/forms @tailwindcss/aspect-ratio @tailwindcss/typography @headlessui/react @heroicons/react")
Dir.chdir destination_root

# Create reusable components
empty_directory "app/components"
empty_directory "app/views/components"

# Create Alert component
create_file "app/components/alert_component.rb" do
%{module #{name.camelize}
  class AlertComponent < ViewComponent::Base
    def initialize(message:, type: :success)
      @message = message
      @type = type
    end

    private

    attr_reader :message, :type
  end
end}
end

create_file "app/views/components/_alert.html.erb" do
%{<div class="rounded-md <%= type == :success ? 'bg-green-50' : 'bg-red-50' %> p-4">
  <div class="flex">
    <div class="flex-shrink-0">
      <% if type == :success %>
        <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
        </svg>
      <% else %>
        <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
        </svg>
      <% end %>
    </div>
    <div class="ml-3">
      <p class="text-sm font-medium <%= type == :success ? 'text-green-800' : 'text-red-800' %>">
        <%= message %>
      </p>
    </div>
  </div>
</div>}
end

# Create Button component
create_file "app/components/button_component.rb" do
%{module #{name.camelize}
  class ButtonComponent < ViewComponent::Base
    def initialize(text:, variant: :primary)
      @text = text
      @variant = variant
    end

    private

    attr_reader :text, :variant
  end
end}
end

create_file "app/views/components/_button.html.erb" do
%{<button class="<%= variant == :primary ? 'bg-blue-500 hover:bg-blue-700' :
                   variant == :secondary ? 'bg-gray-500 hover:bg-gray-700' :
                   'bg-green-500 hover:bg-green-700' %> text-white font-bold py-2 px-4 rounded">
  <%= text %>
</button>}
end

# Create Card component
create_file "app/components/card_component.rb" do
%{module #{name.camelize}
  class CardComponent < ViewComponent::Base
    def initialize(title:, content: nil)
      @title = title
      @content = content
    end

    private

    attr_reader :title, :content
  end
end}
end

create_file "app/views/components/_card.html.erb" do
%{<div class="bg-white overflow-hidden shadow rounded-lg">
  <div class="px-4 py-5 sm:p-6">
    <h3 class="text-lg font-medium text-gray-900"><%= title %></h3>
    <% if content %>
      <p class="mt-2 text-sm text-gray-500"><%= content %></p>
    <% end %>
    <%= content_for?(:content) ? yield(:content) : nil %>
  </div>
</div>}
end

# Add helper module
create_file "app/helpers/#{name}/components_helper.rb" do
%{module #{name.camelize}
  module ComponentsHelper
    def ui_alert(message, type: :success)
      render AlertComponent.new(message: message, type: type)
    end

    def ui_button(text, variant: :primary)
      render ButtonComponent.new(text: text, variant: variant)
    end

    def ui_card(title:, content: nil, &block)
      render CardComponent.new(title: title, content: content), &block
    end
  end
end}
end

# Update engine.rb to include helpers
inject_into_file "lib/#{name}/engine.rb", after: "isolate_namespace #{name.camelize}\n" do
%{
    # Include view helpers
    initializer '#{name}.helpers' do
      ActiveSupport.on_load(:action_controller_base) do
        helper #{name.camelize}::ComponentsHelper
      end
    end
}
end

git_commit "Add Tailwind UI components and styling"

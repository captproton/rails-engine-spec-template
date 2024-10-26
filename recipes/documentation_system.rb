# recipes/documentation_system.rb

intro_message = "📚 Setting up documentation system..."
say(message = intro_message, color: :magenta)

module DocumentationSystem
  # Central registry for documentation sections
  class Registry
    class << self
      def sections
        @sections ||= {}
      end

      def register(name, content, position: :end)
        sections[name] = {
          content: content,
          position: position
        }
      end

      def clear
        @sections = {}
      end

      def features
        sections[:features]&.dig(:content) || []
      end
    end
  end

  # Documentation renderer
  class Renderer
    def initialize(engine_name)
      @engine_name = engine_name
    end

    def render_readme
      content = generate_base_readme
      File.write('README.md', content)
    end

    private

    def generate_base_readme
      <<~MD
        # #{@engine_name.titleize}
        [![Ruby](https://github.com/captproton/#{@engine_name}/actions/workflows/ruby.yml/badge.svg)](https://github.com/captproton/#{@engine_name}/actions/workflows/ruby.yml)

        A modern Rails engine built with Rails 7, Tailwind UI, Stimulus, and Turbo.

        ## Features
        #{render_features}

        ## Installation
        #{render_installation}

        ## Usage
        #{render_usage}
        #{render_configuration}
        #{render_styling}
        #{render_javascript}

        ## Development
        #{render_development}
        #{render_testing}
        #{render_code_style}
        #{render_architecture}

        ## Contributing
        #{render_contributing}

        ## License
        #{render_license}

        ## About
        #{render_about}

        ## Acknowledgments
        #{render_acknowledgments}
      MD
    end

    def render_features
      features = Registry.features
      return DEFAULT_FEATURES if features.empty?

      features.map { |f| "- #{f}" }.join("\n")
    end

    def render_installation
      section = Registry.sections[:installation]&.dig(:content)
      return DEFAULT_INSTALLATION % { name: @engine_name } unless section

      section
    end

    def render_usage
      section = Registry.sections[:usage]&.dig(:content)
      return DEFAULT_USAGE % { name: @engine_name, class_name: @engine_name.camelize } unless section

      section
    end

    def render_configuration
      section = Registry.sections[:configuration]&.dig(:content)
      return DEFAULT_CONFIGURATION % { name: @engine_name, class_name: @engine_name.camelize } unless section

      section
    end

    def render_styling
      section = Registry.sections[:styling]&.dig(:content)
      return DEFAULT_STYLING unless section

      section
    end

    def render_javascript
      section = Registry.sections[:javascript]&.dig(:content)
      return DEFAULT_JAVASCRIPT unless section

      section
    end

    def render_development
      section = Registry.sections[:development]&.dig(:content)
      return DEFAULT_DEVELOPMENT unless section

      section
    end

    def render_testing
      section = Registry.sections[:testing]&.dig(:content)
      return DEFAULT_TESTING unless section

      section
    end

    def render_code_style
      section = Registry.sections[:code_style]&.dig(:content)
      return DEFAULT_CODE_STYLE unless section

      section
    end

    def render_architecture
      section = Registry.sections[:architecture]&.dig(:content)
      return DEFAULT_ARCHITECTURE unless section

      section
    end

    def render_contributing
      section = Registry.sections[:contributing]&.dig(:content)
      return DEFAULT_CONTRIBUTING unless section

      section
    end

    def render_license
      section = Registry.sections[:license]&.dig(:content)
      return DEFAULT_LICENSE unless section

      section
    end

    def render_about
      section = Registry.sections[:about]&.dig(:content)
      return DEFAULT_ABOUT % { name: @engine_name.titleize } unless section

      section
    end

    def render_acknowledgments
      section = Registry.sections[:acknowledgments]&.dig(:content)
      return DEFAULT_ACKNOWLEDGMENTS unless section

      section
    end
  end

  # Default content for sections
  DEFAULT_FEATURES = <<~MD
    - 🚀 Built for Rails 7
    - 📱 Fully responsive design
    - 🧪 Comprehensive test suite with RSpec
  MD

  DEFAULT_INSTALLATION = <<~MD
    Add this line to your application's Gemfile:

    ```ruby
    gem '%{name}'
    ```

    And then execute:
    ```bash
    $ bundle install
    ```

    Or install it yourself as:
    ```bash
    $ gem install %{name}
    ```
  MD

  DEFAULT_USAGE = <<~MD
    Mount the engine in your routes.rb:

    ```ruby
    Rails.application.routes.draw do
      mount %{class_name}::Engine => "/%{name}"
    end
    ```
  MD

  DEFAULT_CONFIGURATION = <<~MD
    ### Configuration
    Add an initializer at `config/initializers/%{name}.rb`:

    ```ruby
    %{class_name}.configure do |config|
      # Add configuration options here
    end
    ```
  MD

  DEFAULT_STYLING = <<~MD
    ### Styling with Tailwind UI
    This engine uses Tailwind UI for styling. Ensure your main app has Tailwind CSS installed and configured.
  MD

  DEFAULT_JAVASCRIPT = <<~MD
    ### JavaScript Components
    The engine includes Stimulus controllers and Turbo features. Make sure your main application includes:

    ```javascript
    import "@hotwired/turbo-rails"
    import "./controllers"
    ```
  MD

  DEFAULT_DEVELOPMENT = <<~MD
    After checking out the repo, run:

    ```bash
    $ bin/setup
    $ bundle exec rspec
    ```

    To run the test application:
    ```bash
    $ cd spec/dummy
    $ bin/dev
    ```

    Visit `http://localhost:3000/dummy_rails7_testing/index` to see the component demos.
  MD

  DEFAULT_TESTING = <<~MD
    ### Running Tests
    ```bash
    $ bundle exec rspec
    ```
  MD

  DEFAULT_CODE_STYLE = <<~MD
    ### Code Style
    This project uses:
    - RuboCop for Ruby code style
    - ESLint for JavaScript
    - Prettier for formatting
  MD

  DEFAULT_ARCHITECTURE = <<~MD
    ### Architecture
    This engine follows these principles:
    - Modular design
    - Isolated scope
    - Clear API boundaries
    - Comprehensive testing
    - Modern Rails patterns
  MD

  DEFAULT_CONTRIBUTING = <<~MD
    1. Fork it
    2. Create your feature branch (`git checkout -b feature/my-new-feature`)
    3. Commit your changes (`git commit -am 'Add some feature'`)
    4. Push to the branch (`git push origin feature/my-new-feature`)
    5. Create new Pull Request
  MD

  DEFAULT_LICENSE = <<~MD
    The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
  MD

  DEFAULT_ABOUT = <<~MD
    %{name} is maintained by [Your Name/Company]. If you have any questions, feel free to reach out or open an issue.
  MD

  DEFAULT_ACKNOWLEDGMENTS = <<~MD
    This engine was generated using the [rails-engine-spec-template](https://github.com/captproton/rails-engine-spec-template).
  MD
end

# Create helper module
create_file "lib/#{name}/documentation_helper.rb" do
  <<~RUBY
    module #{name.camelize}
      module DocumentationHelper
        def self.register_doc_section(name, content, position: :end)
          DocumentationSystem::Registry.register(name, content, position: position)
        end
      end
    end
  RUBY
end

# Register base documentation
#{name.camelize}::DocumentationHelper.register_doc_section(
  :features,
  [
    "🚀 Built for Rails 7",
    "📱 Fully responsive design",
    "🧪 Comprehensive test suite with RSpec"
  ]
)

# Generate initial README
DocumentationSystem::Renderer.new(name).render_readme

git_commit "Initialize documentation system"

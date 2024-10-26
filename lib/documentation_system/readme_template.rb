# frozen_string_literal: true

module DocumentationSystem
  class ReadmeTemplate
    def initialize(engine_name)
      @engine_name = engine_name
    end

    def render(registry)
      @registry = registry
      [
        render_header,
        render_description,
        render_features,
        render_installation,
        render_configuration,
        render_usage,
        render_development,
        render_testing,
        render_contributing,
        render_license,
        render_about,
        render_acknowledgments
      ].compact.join("\n\n")
    end

    private

    attr_reader :registry, :engine_name

    def render_header
      <<~MD
        # #{engine_name.titleize}
        [![Ruby](https://github.com/captproton/#{engine_name}/actions/workflows/ruby.yml/badge.svg)](https://github.com/captproton/#{engine_name}/actions/workflows/ruby.yml)
      MD
    end

    def render_description
      section = registry.get(:description)
      content = section&.content || DEFAULT_DESCRIPTION
      content % { name: engine_name }
    end

    def render_features
      features = registry.features
      return "## Features\n#{DEFAULT_FEATURES}" if features.empty?

      <<~MD
        ## Features

        #{features.map { |f| "- #{f}" }.join("\n")}
      MD
    end

    def render_installation
      section = registry.get(:installation)
      content = section&.content || DEFAULT_INSTALLATION

      <<~MD
        ## Installation

        #{content % { name: engine_name }}
      MD
    end

    def render_configuration
      base_config = registry.get(:configuration)&.content || DEFAULT_CONFIGURATION
      meta_config = registry.get(:meta_configuration)&.content
      tailwind_config = registry.get(:tailwind_configuration)&.content

      sections = [
        "## Configuration",
        base_config % { name: engine_name, class_name: engine_name.camelize }
      ]

      sections << meta_config if meta_config
      sections << tailwind_config if tailwind_config

      sections.join("\n\n")
    end

    def render_usage
      sections = ["## Usage"]

      base_usage = registry.get(:usage)&.content || DEFAULT_USAGE
      sections << (base_usage % { name: engine_name, class_name: engine_name.camelize })

      [:components, :javascript, :styling].each do |section_name|
        if (section = registry.get(section_name)&.content)
          sections << section
        end
      end

      sections.join("\n\n")
    end

    def render_development
      sections = ["## Development"]

      base_dev = registry.get(:development)&.content || DEFAULT_DEVELOPMENT
      sections << base_dev

      [:development_tools, :development_environment].each do |section_name|
        if (section = registry.get(section_name)&.content)
          sections << section
        end
      end

      sections.join("\n\n")
    end

    def render_testing
      section = registry.get(:testing)
      return if section.nil? && !registry.features.any? { |f| f.include?("test") }

      content = section&.content || DEFAULT_TESTING

      <<~MD
        ### Testing
        #{content}
      MD
    end

    def render_contributing
      <<~MD
        ## Contributing

        1. Fork it
        2. Create your feature branch (`git checkout -b feature/my-new-feature`)
        3. Commit your changes (`git commit -am 'Add some feature'`)
        4. Push to the branch (`git push origin feature/my-new-feature`)
        5. Create new Pull Request
      MD
    end

    def render_license
      <<~MD
        ## License

        The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
      MD
    end

    def render_about
      section = registry.get(:about)
      content = section&.content || DEFAULT_ABOUT

      <<~MD
        ## About

        #{content % { name: engine_name.titleize }}
      MD
    end

    def render_acknowledgments
      <<~MD
        ## Acknowledgments

        This engine was generated using the [rails-engine-spec-template](https://github.com/captproton/rails-engine-spec-template).
      MD
    end

    DEFAULT_DESCRIPTION = "A modern Rails engine built with Rails 7, Tailwind UI, Stimulus, and Turbo."

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

    DEFAULT_CONFIGURATION = <<~MD
      Add an initializer at `config/initializers/%{name}.rb`:

      ```ruby
      %{class_name}.configure do |config|
        # Add configuration options here
      end
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

    DEFAULT_DEVELOPMENT = <<~MD
      After checking out the repo, run:

      ```bash
      $ bin/setup
      $ bin/dev
      ```

      Visit `http://localhost:3000/dummy_rails7_testing/index` to see the component demos.
    MD

    DEFAULT_TESTING = <<~MD
      Run the test suite:

      ```bash
      $ bundle exec rspec
      ```

      The test suite includes:
      - Unit tests for models and services
      - Integration tests for controllers
      - System tests for UI components
    MD

    DEFAULT_ABOUT = <<~MD
      %{name} is maintained by [Your Name/Company].
      If you have any questions, feel free to reach out or open an issue.
    MD
  end
end

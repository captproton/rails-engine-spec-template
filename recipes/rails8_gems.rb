intro_message = "🙏 Installing Rails 8 dependencies (importmap, stimulus, turbo)..."
say(intro_message, :magenta)

# Add all dependencies at once
inject_into_file GEMSPEC_FILE, before: %r{^end$} do
%{
  spec.add_dependency 'importmap-rails'
  spec.add_dependency 'stimulus-rails'
  spec.add_dependency 'turbo-rails'
  spec.required_ruby_version = '>= 3.2.0'
}
end

# Single bundle install for all gems
bundle

# Set up application directory
app_dir = "#{destination_root}/spec/dummy"
Dir.chdir app_dir
FileUtils.touch "#{app_dir}/Gemfile"

# Create broadcast adapter class first
create_file "lib/#{name}/broadcast_adapter.rb" do
%{module #{camelized}
  class BroadcastAdapter
    class << self
      attr_writer :adapter

      def adapter
        @adapter ||= :action_cable
      end

      def broadcast_to(stream, content)
        case adapter
        when :action_cable
          Turbo::StreamsChannel.broadcast_to(stream, content)
        when :pusher
          # Implement Pusher adapter
        when :redis
          # Implement Redis adapter
        else
          raise ArgumentError, "Unknown broadcast adapter: \#{adapter}"
        end
      end
    end
  end
end}
end

# Update the main library file to require broadcast_adapter
inject_into_file "lib/#{name}.rb", before: "require \"#{name}/engine\"" do
%{require "#{name}/broadcast_adapter"
}
end

# Add broadcasting configuration to engine
inject_into_file "lib/#{name}/engine.rb", after: "isolate_namespace #{camelized}\n" do
%{
    # Configure broadcasting adapter
    config.broadcasting_adapter = :action_cable

    initializer "#{name}.broadcasting", before: :load_config_initializers do
      config.after_initialize do
        #{camelized}::BroadcastAdapter.adapter = config.broadcasting_adapter
      end
    end
}
end

# Install JavaScript dependencies
step_message = "🧩 Setting up JavaScript..."
say(step_message)
Dir.chdir app_dir

# Create necessary JavaScript directories
empty_directory "app/javascript"
empty_directory "app/javascript/controllers"

# Create JavaScript files
create_file "config/importmap.rb" do
%{# Pin npm packages by running ./bin/importmap

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"}
end

create_file "app/javascript/application.js" do
%{// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"}
end

create_file "app/javascript/controllers/application.js" do
%{import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }}
end

create_file "app/javascript/controllers/index.js" do
%{// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)}
end

create_file "app/javascript/controllers/hello_controller.js" do
%{import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Hello Stimulus!")
  }
}}
end

# Set up ActionCable for broadcasting
create_file "#{app_dir}/app/channels/application_cable/channel.rb" do
%{module ApplicationCable
  class Channel < ActionCable::Channel::Base
  end
end}
end

create_file "#{app_dir}/app/channels/application_cable/connection.rb" do
%{module ApplicationCable
  class Connection < ActionCable::Connection::Base
  end
end}
end

# Update application.html.erb to include JavaScript
inject_into_file "app/views/layouts/application.html.erb", before: "</head>" do
%{    <%= javascript_importmap_tags %>
}
end

# Create test controller
step_message = "🧩 Creating test controller..."
say(step_message)
create_file "#{app_dir}/app/controllers/dummy_rails7_testing_controller.rb" do
%{class DummyRails7TestingController < ApplicationController
  def index
  end

  def broadcast
    #{camelized}::BroadcastAdapter.broadcast_to(
      "test_stream",
      turbo_stream.append("messages", partial: "message", locals: { message: params[:message] })
    )
    head :ok
  end
end}
end

# Create view
create_file "#{app_dir}/app/views/dummy_rails7_testing/index.html.erb" do
%{<div data-controller="hello" class="container mx-auto p-4">
  <h1 class="text-2xl font-bold mb-4">Rails 8 Engine Test Page</h1>
  <div id="messages" class="space-y-4"></div>
</div>}
end

Dir.chdir destination_root

git_commit "Update Rails 8 JavaScript setup and configurations"
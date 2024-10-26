# recipes/setup_overmind.rb
intro_message = "🚀 Setting up Overmind development environment..."
say(message = intro_message, color: :magenta)

# Register documentation
# #{name.camelize}::DocumentationHelper.register_doc_section(
#   :features,
#   ["⚡️ Streamlined development workflow with Overmind"]
# )

# #{name.camelize}::DocumentationHelper.register_doc_section(
#   :development_environment,
#   {
#     title: "Development Environment",
#     content: <<~MD
#       ### Development Setup

#       This engine uses Overmind to manage development processes:

#       1. Install Overmind:
#       ```bash
#       brew install overmind
#       ```

#       2. Start the development environment:
#       ```bash
#       cd spec/dummy
#       ./bin/dev
#       ```

#       This starts:
#       - Rails server (port 3000)
#       - Tailwind CSS watcher
#       - Additional configured processes

#       ### Overmind Commands
#       While running, use:
#       - `ctrl-z` to access command mode
#       - In command mode:
#         - `r` - restart process
#         - `c` - connect to process
#         - `m` - show process logs
#         - `h` - help
#         - `q` - quit

#       ### Process Configuration
#       Processes are defined in `spec/dummy/Procfile.dev`:
#       ```
#       web: bin/rails server -p 3000
#       css: bin/rails tailwindcss:watch
#       ```

#       Add additional processes as needed for your development workflow.
#     MD
#   },
#   position: :after_installation
# )

# Create Procfile.dev
create_file "spec/dummy/Procfile.dev" do
%{web: bin/rails server -p 3000
css: bin/rails tailwindcss:watch
}
end

# Create bin/dev script
create_file "spec/dummy/bin/dev" do
%{#!/usr/bin/env bash

if ! command -v overmind &> /dev/null
then
    echo "Overmind is required. Install it with:"
    echo "brew install overmind"
    exit 1
fi

# Default to port 3000 if not specified
export PORT="${PORT:-3000}"
export OVERMIND_PROCFILE=Procfile.dev

exec overmind start
}
end

# Make bin/dev executable
chmod "spec/dummy/bin/dev", 0755

# Update README with development instructions
inject_into_file "README.md", after: "## Development\n\n" do
%{### Starting the Development Environment

First, ensure Overmind is installed:
```bash
brew install overmind
```

To start the development environment with all processes:
```bash
cd spec/dummy
./bin/dev
```

This will start:
- Rails server on port 3000
- Tailwind CSS watcher
- Any other processes defined in `spec/dummy/Procfile.dev`

Overmind commands while running:
- `ctrl-z` to access Overmind's command mode
- In command mode:
  - `r` to restart a process
  - `c` to connect to a process
  - `m` to show process logs
  - `h` for help
  - `q` to quit

}
end

# Add instructions for first-time setup
append_to_file "spec/dummy/README.md" do
%{# Development Setup

This is the test application for #{name}. To set up your development environment:

1. Ensure you have Overmind installed:
   ```bash
   brew install overmind
   ```

2. Start the development environment:
   ```bash
   ./bin/dev
   ```

This will start all necessary processes for development.
}
end

git_commit "Add Overmind development environment setup"

# recipes/setup_overmind.rb
intro_message = "🚀 Setting up Overmind development environment..."
say(intro_message, :magenta)

# Create bin/dev script for Overmind
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
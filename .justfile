#!/usr/bin/env just --justfile

set dotenv-load
set positional-arguments

# Constants/Preferences
user := 'ada'

# Get the project name from 'name' in '[project]' in 'pyproject.toml'
project_name := `awk '/^\[project\]/ { proj = 1 } proj && /^name = / { gsub(/"/, "", $3); print $3; exit }' pyproject.toml`

# Print system info and available `just` recipes
_default:
  @echo "This is an {{arch()}} machine with {{num_cpus()}} cpu(s), on {{os()}}."
  @echo "Running: {{just_executable()}}"
  @echo "   with: {{justfile()}}"
  @echo "     in: {{invocation_directory_native()}}"
  @echo ""
  @just --list


### Infrastructure

tofu_root := "infra/"

# Just proxy a `tofu` command in the root infra directory
[group('infra')]
tofu *args:
  @cd {{tofu_root}} && tofu {{args}}

# Switch to an OpenTofu workspace
[group('infra')]
tofu-workspace-select workspace:
  @cd {{tofu_root}} && tofu workspace select {{workspace}}

# Print the current OpenTofu workspace
[group('infra')]
tofu-workspace-show:
  @cd {{tofu_root}} && tofu workspace show

# Get ouput `key` from the OpenTofu `workspace`, or print all
[group('infra')]
tofu-get-output workspace key='':
  #!/usr/bin/env bash
  old_workspace=$(just tofu-workspace-show)
  just -q tofu-workspace-select {{workspace}}
  cd {{tofu_root}} && tofu output $([ -n "{{key}}" ] && echo "-raw {{key}}" || echo "")
  just -q tofu-workspace-select $old_workspace


### Workflow

# SSH into the server for `env` environment
[group('workflow')]
ssh env="dev":
  #!/usr/bin/env bash
  server_ip=$(just -q tofu-get-output {{env}} server_ip)
  echo "Connecting to {{env}} server at $server_ip..."
  ssh {{user}}@$server_ip

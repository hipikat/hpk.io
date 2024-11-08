#!/usr/bin/env just --justfile

set dotenv-load
set positional-arguments

# Constants/Preferences
user := "${DEVELOPER}"

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
tofu_env_cmds := "plan apply destroy"
db_name := "hpkio_db"

# Run an OpenTofu command; uses applicable tfvar files, gets raw output
[group('infra')]
[no-exit-message]
tofu *args='':
  #!/usr/bin/env bash
  args=({{args}})
  cd {{tofu_root}}
  if [[ " {{tofu_env_cmds}} " =~ " ${args[0]} " ]]; then
    args=("${args[0]} -var-file=settings.tfvars -var-file=secrets.tfvars" "${args[@]:1}")
    tofu_env=$(just tofu workspace show)
    if [ -f "envs/$tofu_env.tfvars" ]; then
      args=("${args[0]}" "-var-file=envs/$tofu_env.tfvars" "${args[@]:1}")
    fi
  elif [[ "${args[0]}" == "output" && ${#args[@]} -gt 1 ]]; then
    args=("${args[0]} -raw" "${args[@]:1}")
  fi
  tofu ${args[@]}

# Run an OpenTofu command against a specific workspace
[group('infra')]
tofu-in workspace='' *args='':
  #!/usr/bin/env bash
  old_workspace=$(just tofu workspace show)
  cd {{tofu_root}}
  [ "{{workspace}}" != "$old_workspace" ] && tofu workspace select {{workspace}} > /dev/null
  just -q tofu {{args}}
  [ "{{workspace}}" != "$old_workspace" ] && tofu workspace select $old_workspace > /dev/null

# Run tofu in infra/managed_volume/, in a workspace named for the volume
[group('infra')]
[no-exit-message]
tofu-volume *args='':
  #!/usr/bin/env bash
  args=({{args}})
  cd {{tofu_root}}managed_volume/
  if [[ " {{tofu_env_cmds}} " =~ " ${args[0]} " ]]; then
    args=("${args[0]} -var-file=../settings.tfvars -var-file=../secrets.tfvars" "${args[@]:1}")
    volume_name=$(just tofu-volume workspace show)
    if [ -f "$volume_name.tfvars" ]; then
      args=("${args[0]}" "-var-file=$volume_name.tfvars" "${args[@]:1}")
    else
      echo "error: In $(pwd); no $volume_name.tfvars file found." >&2
    fi
  elif [[ "${args[0]}" == "output" && ${#args[@]} -gt 1 ]]; then
    args=("${args[0]} -raw" "${args[@]:1}")
  fi
  # echo "Running tofu with ${args[@]}"
  tofu ${args[@]}

# Attach a named volume to specified server
[group('infra')]
volume-attach volume_name droplet_name:
  #!/usr/bin/env bash
  volume_id=$(doctl compute volume list --format Name,ID --no-header | grep -w "^{{volume_name}}" | awk '{print $2}')
  if [ -z "$volume_id" ]; then
    echo "error: Volume '{{volume_name}}' not found." >&2
    exit 1
  fi
  droplet_id=$(doctl compute droplet list --format Name,ID --no-header | grep -w "^{{droplet_name}}" | awk '{print $2}')
  if [ -z "$droplet_id" ]; then
    echo "error: Droplet '{{droplet_name}}' not found." >&2
    exit 1
  fi
  echo "Attaching volume '{{volume_name}}' (ID: $volume_id) to droplet '{{droplet_name}}' (ID: $droplet_id)..."
  doctl compute volume-action attach "$volume_id" "$droplet_id" --wait

# Detach a named volume from any server it's attached to
[group('infra')]
volume-detach volume_name:
  #!/usr/bin/env bash
  volume_id=$(doctl compute volume list --format Name,ID --no-header | grep -w "^{{volume_name}}" | awk '{print $2}')
  if [ -z "$volume_id" ]; then
    echo "error: Volume '{{volume_name}}' not found." >&2
    exit 1
  fi
  current_droplet_id=$(doctl compute volume get "$volume_id" --format DropletIDs --no-header | jq -r '.[0]')
  if [ "$current_droplet_id" = "null" ]; then
    echo "Volume '{{volume_name}}' is already detached."
  else
    echo "Detaching volume '{{volume_name}}' (ID: $volume_id) from droplet ID $current_droplet_id..."
    doctl compute volume-action detach $volume_id $current_droplet_id --wait
  fi

# Mount a volume attached to a container to a specific path
[group('infra')]
volume-mount volume_name mount_point:
  #!/usr/bin/env bash
  just ssh "\
    mkdir -p {{mount_point}};\
    sudo mount -o discard,defaults,noatime /dev/disk/by-id/scsi-0DO_Volume_{{volume_name}} {{mount_point}};\
    echo '/dev/disk/by-id/scsi-0DO_Volume_{{volume_name}} {{mount_point}} ext4 defaults,nofail,discard 0 0' | sudo tee -a /etc/fstab;\
    echo 'Volume {{volume_name}} mounted at {{mount_point}}.'\
  "

### Python/Django

# Run a Python command
[group('python')]
py *args='':
  uv run python {{args}}

# Run a Django management command
[group('python')]
dj *args='':
  uv run python src/manage.py {{args}}


### Linting

# Rewrite all OpenTofu config files into the canonical format
[group('lint')]
lint-tofu:
  @find infra/ -type f \( -name '*.tf' -o -name '*.tfvars' -o -name '*.tftest.hcl' \) -exec tofu fmt {} +

# Run all lint commands across the project
[group('lint')]
lint:
  just lint-tofu


### Workflow

# Run django-extensions' `runserver_plus` development server
[group('workflow')]
_develop-local:
  @just dj runserver_plus

# # Run a dev server with Docker Compose
# [group('workflow')]
# _develop-docker:
#   # should just require `docker-compose` up

# # Run a dev server in the cloud
# [group('workflow')]
# _develop-local:
#   # run `tofu apply` against the dev environment?

# Run a development server
[group('workflow')]
develop target='local':
  @just _develop-{{target}}

# Make and run Django migrations
[group('workflow')]
migrate:
  just dj makemigrations
  just dj migrate

# Run an ssh command against the current workspace (or just ssh in)
[group('workflow')]
ssh *args='':
  #!/usr/bin/env bash
  workspace=$(just -q tofu workspace show)
  just ssh-in $workspace "{{args}}"

# Run ssh against the server for the specified environment
[group('workflow')]
ssh-in env *args='':
  #!/usr/bin/env bash
  # args=({{args}})
  server_ip=$(just -q tofu-in {{env}} output server_ip 2> /dev/null)
  if [ $(echo "$server_ip" | wc -l) -ne 1 ]; then
    echo "error: Could not determine server IP for {{env}} environment." >&2
    exit 1
  fi
  # if [[ ${#args[@]} -gt 0 ]]; then
  #   echo "Running command on {{env}} server at $server_ip..."
  # else
  #   echo "Connecting to {{env}} server at $server_ip..."
  # fi
  # ssh {{user}}@$server_ip "${args[@]}"
  ssh {{user}}@$server_ip "{{args}}"

# Update 'magic' strings in the project from values in .env
[group('workflow')]
update-magic:
  @scripts/update_magic.sh

# Build and collect JS & CSS, and watch for changes in source
[group('workflow')]
watch:
  npm run watch:build
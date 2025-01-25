#!/usr/bin/env -S just --justfile

set dotenv-load := true
set positional-arguments := true

# Constants/Preferences

user := "${DEVELOPER}"
editables := '''
repos="picata django"
declare -A upstreams origins extras
upstreams=(
    [django]="https://github.com/django/django.git"
    [pre-commit]="https://github.com/pre-commit/pre-commit.git"
    [pygments]="https://github.com/pygments/pygments.git"
    [ruff]="https://github.com/astral-sh/ruff"
    [wagtail]="https://github.com/wagtail/wagtail.git"
)
origins=(
    [django]="git@github.com:hipikat/django.git"
    [wagtail]="git@github.com:hipikat/wagtail.git"
    [picata]="git@github.com:hipikat/picata.git"
    [pre-commit]="git@github.com:hipikat/pre-commit.git"
)
extras=(
    [wagtail]="[testing, docs]"
)
post_install_picata() {
    uv sync --all-groups
}
pre_install_wagtail() {
    echo "Installing Node toolchain for Wagtail..."
    npm ci
    echo "Compiling assets for Wagtail..."
    npm run build
}
post_install_wagtail() {
    uv pip install ruff --upgrade
    editable_path=$(echo build/__editable__.*)
    static_dirs=(
        "wagtail/admin/static/"
        "wagtail/documents/static/"
        "wagtail/embeds/static/"
        "wagtail/images/static/"
        "wagtail/contrib/search_promotions/static/"
        "wagtail/users/static/"
    )
    for dir in "${static_dirs[@]}"; do
        dest="$editable_path/$dir"
        if [ -d "$dir" ]; then
            echo "Copying static files from $dir to $dest..."
            mkdir -p "$dest"
            cp -r "$dir"/* "$dest"
        else
            echo "Warning: Source directory $dir does not exist. Skipping..."
        fi
    done
    echo "Static files copied successfully."
}
'''

# Default command flags

uv_sync := if env_var_or_default("UV_NO_SYNC", "false") == "true" { "--no-sync" } else { "" }

# Get the project name from 'name' in '[project]' in 'pyproject.toml

project_name := `awk '/^\[project\]/ { proj = 1 } proj && /^name = / { gsub(/"/, "", $3); print $3; exit }' pyproject.toml`

# Print system info and available `just` recipes
_default:
    @echo "This is an {{ arch() }} machine with {{ num_cpus() }} cpu(s), on {{ os() }}."
    @echo "Running: {{ just_executable() }}"
    @echo "   with: {{ justfile() }}"
    @echo "     in: {{ invocation_directory_native() }}"
    @echo ""
    @just --list

### Infrastructure

tofu_root := "infra/"
tofu_env_cmds := "plan apply destroy"
tofu_dotenv_vars := "TIMEZONE TLD DB_NAME DB_USER ADMIN_DJANGO_USER ADMIN_EMAIL_NAME"

# Generate an HCL-compattible file from the .env file at infra/dot_env.tfvars
[group('infra')]
_dotenv-for-tofu:
    #!/usr/bin/env bash
    whitelist="{{ tofu_dotenv_vars }}"
    {
      echo "# This file was generated by the '_dotenv-for-tofu' recipe in the Justfile."
      echo "# Do not edit this file manually; changes will be overwritten.\n"
      grep -v '^#' .env | grep -v '^[[:space:]]*$' | awk -F= -v whitelist="$whitelist" '{
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1);
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2);
        if ((" " whitelist " ") ~ (" " $1 " ")) {
          print tolower($1) " = \"" $2 "\""
        }
      }'
    } > infra/dot_env.tfvars

# Run an OpenTofu command; uses applicabletfvar files, gets raw output
[group('infra')]
[no-exit-message]
tofu *args='': _dotenv-for-tofu
    #!/usr/bin/env bash
    args=({{ args }})
    cd {{ tofu_root }}
    if [[ " {{ tofu_env_cmds }} " =~ " ${args[0]} " ]]; then
      args=("${args[0]} -var-file=dot_env.tfvars -var-file=settings.tfvars -var-file=secrets.tfvars" "${args[@]:1}")
      tofu_env=$(just tofu workspace show)
      if [ -f "envs/$tofu_env.tfvars" ]; then
        args=("${args[0]}" "-var-file=envs/$tofu_env.tfvars" "${args[@]:1}")
      fi
      public_ip=$(curl -s http://checkip.amazonaws.com)
      if [ -z "$public_ip" ]; then
        echo "error: Could not fetch public IP." >&2
        exit 1
      fi
      args=("${args[0]}" "-var=internal_ips=${public_ip}" "${args[@]:1}")
    elif [[ "${args[0]}" == "output" && ${#args[@]} -gt 1 ]]; then
      args=("${args[0]} -raw" "${args[@]:1}")
    fi
    tofu ${args[@]}

# Run an OpenTofu command against a specific workspace
[group('infra')]
tofu-in workspace='' *args='':
    #!/usr/bin/env bash
    cd {{ tofu_root }}
    old_workspace=$(tofu workspace show)
    trap 'tofu workspace select "$old_workspace" > /dev/null' EXIT
    if ! tofu workspace list | grep -q "^[* ] {{ workspace }}$"; then
        echo "Workspace '{{ workspace }}' does not exist."
        read -p "Would you like to create this workspace? [y/N]: " create_response
        create_response=${create_response,,}
        if [[ "$create_response" == "y" || "$create_response" == "yes" ]]; then
            echo "Creating workspace '{{ workspace }}'..."
            tofu workspace new "{{ workspace }}"
        else
            echo "Aborting. Workspace '{{ workspace }}' was not created."
            exit 1
        fi
    elif [ "{{ workspace }}" != "$old_workspace" ]; then
        tofu workspace select "{{ workspace }}" > /dev/null
    fi
    just tofu {{ args }}

# Run tofu in infra/managed_volume, in a workspace named for the volume
[group('infra')]
[no-exit-message]
tofu-volume *args='': _dotenv-for-tofu
    #!/usr/bin/env bash
    args=({{ args }})
    cd {{ tofu_root }}managed_volume/
    if [[ " {{ tofu_env_cmds }} " =~ " ${args[0]} " ]]; then
      args=("${args[0]} -var-file=../dot_env.tfvars -var-file=../settings.tfvars -var-file=../secrets.tfvars" "${args[@]:1}")
      volume_name=$(just tofu-volume workspace show)
      if [ -f "$volume_name.tfvars" ]; then
        args=("${args[0]}" "-var-file=$volume_name.tfvars" "${args[@]:1}")
      else
        echo "error: In $(pwd); no $volume_name.tfvars file found." >&2
      fi
    elif [[ "${args[0]}" == "output" && ${#args[@]} -gt 1 ]]; then
      args=("${args[0]} -raw" "${args[@]:1}")
    fi
    tofu ${args[@]}

# List DigitalOcean volumes
[group('infra')]
volume-list:
    doctl compute volume list --format 'Name,ID,Region,Size,DropletIDs,Tags'

# List DigitalOcean Volume snapshots
[group('infra')]
volume-snapshot-list:
    doctl compute snapshot list --resource volume --format 'Name,ID,ResourceId,CreatedAt,Size,MinDiskSize,Tags'

# Attach a named volume to specified server
[group('infra')]
[no-exit-message]
volume-attach volume_name droplet_name:
    #!/usr/bin/env bash
    volume_id=$(doctl compute volume list --format Name,ID --no-header | grep -w "^{{ volume_name }}" | awk '{print $2}')
    if [ -z "$volume_id" ]; then
      echo "error: Volume '{{ volume_name }}' not found." >&2
      exit 1
    fi
    droplet_id=$(doctl compute droplet list --format Name,ID --no-header | grep -w "^{{ droplet_name }}" | awk '{print $2}')
    if [ -z "$droplet_id" ]; then
      echo "error: Droplet '{{ droplet_name }}' not found." >&2
      exit 1
    fi
    echo "Attaching volume '{{ volume_name }}' (ID: $volume_id) to droplet '{{ droplet_name }}' (ID: $droplet_id)..."
    doctl compute volume-action attach "$volume_id" "$droplet_id" --wait

# Detach a named volume from any server it's attached to
[group('infra')]
[no-exit-message]
volume-detach volume_name:
    #!/usr/bin/env bash
    volume_id=$(doctl compute volume list --format Name,ID --no-header | grep -w "^{{ volume_name }}" | awk '{print $2}')
    if [ -z "$volume_id" ]; then
      echo "error: Volume '{{ volume_name }}' not found." >&2
      exit 1
    fi
    current_droplet_id=$(doctl compute volume get "$volume_id" --format DropletIDs --no-header | jq -r '.[0]')
    if [ "$current_droplet_id" = "null" ]; then
      echo "Volume '{{ volume_name }}' is already detached."
    else
      echo "Detaching volume '{{ volume_name }}' (ID: $volume_id) from droplet ID $current_droplet_id..."
      doctl compute volume-action detach $volume_id $current_droplet_id --wait
    fi

# Mount a volume attached to a container to a specific path
[group('infra')]
volume-mount volume_name mount_point:
    #!/usr/bin/env bash
    just ssh "\
      mkdir -p {{ mount_point }};\
      sudo mount -o discard,defaults,noatime /dev/disk/by-id/scsi-0DO_Volume_{{ volume_name }} {{ mount_point }};\
      echo '/dev/disk/by-id/scsi-0DO_Volume_{{ volume_name }} {{ mount_point }} ext4 defaults,nofail,discard 0 0' | sudo tee -a /etc/fstab;\
      echo 'Volume {{ volume_name }} mounted at {{ mount_point }}.'\
    "

# Make a snapshot image of a volume
[group('infra')]
[no-exit-message]
volume-snapshot volume_name snapshot_name="":
    #!/usr/bin/env bash
    volume_name="{{ volume_name }}"
    volume_id=$(doctl compute volume list --format Name,ID --no-header | grep -w "^$volume_name\b" | awk '{print $2}')
    snapshot_name=${snapshot_name:-$volume_name}
    doctl compute volume snapshot $volume_id --snapshot-name $snapshot_name

# Bring up and sync an environment in the cloud
[group('infra')]
deploy env:
    just tofu-in {{ env }} apply

# Take down a cloud environment (warning: DESTRUCTIVE!)
[group('infra')]
teardown env:
    just tofu-in {{ env }} destroy

### Python/Django

# Run a Python command
[group('python')]
py *args='':
    uv run {{ uv_sync }} $UV_FLAGS python {{ args }}

# Run a Django management command
[group('python')]
dj *args='':
    uv run {{ uv_sync }} python src/manage.py {{ args }}

# Run Python code in the Django shell
[group('python')]
dj-shell *command='':
    uv run {{ uv_sync }} python src/manage.py shell -c "{{ command }}"

# Create superuser with a non-interactive password setting
[group('python')]
dj-createsuperuser user='' email='' password='':
    #!/usr/bin/env bash
    effective_user="{{ user }}"
    if [[ -z "$effective_user" && -n "$ADMIN_DJANGO_USER" ]]; then
        effective_user="$ADMIN_DJANGO_USER"
    fi
    effective_email="{{ email }}"
    if [[ -z "$effective_email" && -n "$ADMIN_EMAIL" ]]; then
        effective_email="$ADMIN_EMAIL"
    fi
    effective_password="{{ password }}"
    if [[ -z "$effective_password" && -n "$ADMIN_PASSWORD" ]]; then
        effective_password="$ADMIN_PASSWORD"
    fi
    if [[ -z "$effective_user" || -z "$effective_email" || -z "$effective_password" ]]; then
        echo "Error: Missing required arguments or environment variables."
        echo "Provide --user, --email, and --password arguments, or set ADMIN_DJANGO_USER, ADMIN_EMAIL, and ADMIN_PASSWORD in the environment."
        exit 1
    fi
    user_exists=$(just dj-shell "
    from django.contrib.auth import get_user_model
    User = get_user_model()
    print(User.objects.filter(username='$effective_user').exists())
    ")
    if [[ "$user_exists" == "True" ]]; then
        echo "Superuser '$effective_user' already exists. Skipping creation."
    else
        just dj createsuperuser --noinput --username="$effective_user" --email="$effective_email"
    fi
    just dj-shell "
    from django.contrib.auth import get_user_model
    User = get_user_model()
    user = User.objects.get(username='$effective_user')
    user.set_password('$effective_password')
    user.save()
    print('Superuser password set successfully.')
    "

### Environment

# Remove the Node environment
[group('environment')]
nuke-node:
    rm -rf node_modules

# Destroy the Python virtual environment
[group('environment')]
nuke-python:
    rm -rf .venv .mypy_cache

# Remove local images built by Docker Commpose services
[group('environment')]
nuke-compose:
    just compose-clean
    docker compose down --rmi local

# Remove the Python and Node environments and destroy the database.
[group('environment')]
scorch:
    just nuke-python
    just nuke-node
    just nuke-compose
    just db-drop

# Create the database, and try to create a Django superuser
[group('environment')]
db-create db_password='':
    #!/usr/bin/env bash
    psql_cmd=$([[ "$(uname)" == "Darwin" ]] && echo "psql" || echo "sudo -u postgres psql")
    createdb_cmd=$([[ "$(uname)" == "Darwin" ]] && echo "createdb" || echo "sudo -u postgres createdb")
    effective_password="{{ db_password }}"
    if [[ -z "$effective_password" && -n "$DB_PASSWORD" ]]; then
        effective_password="$DB_PASSWORD"
    fi
    role_exists=$($psql_cmd -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER';")
    if [[ "$role_exists" == "1" ]]; then
      echo "Role $DB_USER exists."
      if [[ -n "$effective_password" ]]; then
        echo "Updating password for role $DB_USER..."
        $psql_cmd -c "ALTER ROLE $DB_USER WITH PASSWORD '$effective_password';"
      else
        echo "Unsetting password for role $DB_USER..."
        $psql_cmd -c "ALTER ROLE $DB_USER WITH PASSWORD NULL;"
      fi
    else
      if [[ -n "$effective_password" ]]; then
        echo "Creating role $DB_USER with password..."
        $psql_cmd -c "CREATE ROLE $DB_USER WITH LOGIN PASSWORD '$effective_password';"
      else
        echo "Creating role $DB_USER without a password..."
        $psql_cmd -c "CREATE ROLE $DB_USER WITH LOGIN;"
      fi
    fi
    echo "Granting CREATEDB privilege to $DB_USER..."
    $psql_cmd -c "ALTER ROLE $DB_USER CREATEDB;"
    echo "Checking for database $DB_NAME..."
    db_exists=$($psql_cmd -tA -c "SELECT 1 FROM pg_database WHERE datname='$DB_NAME';")
    if [[ "$db_exists" == "1" ]]; then
      echo "Database $DB_NAME already exists. Skipping creation."
    else
      echo "Creating database $DB_NAME owned by $DB_USER..."
      $createdb_cmd -O $DB_USER $DB_NAME
    fi

[group('environment')]
db-init db_password='':
    #!/usr/bin/env bash
    just db-create "{{ db_password }}"
    echo "Attempting to load snapshot..."
    if ! ./scripts/load_snapshot.sh; then
      echo "Couldn't load snapshot; applying migrations to initialize database."
      uv run {{ uv_sync }} python src/manage.py migrate
    fi

# Drop the application database and associated user, if they exist
[group('environment')]
db-drop:
    #!/usr/bin/env bash
    prefix=$([[ "$(uname)" == "Darwin" ]] && echo "" || echo "sudo -u postgres")
    if $prefix psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME';" | grep -q 1; then
      echo "Database $DB_NAME found. Dropping it..."
      $prefix psql -c "DROP DATABASE $DB_NAME;"
    else
      echo "Database $DB_NAME does not exist. Skipping drop."
    fi
    if $prefix psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER';" | grep -q 1; then
      echo "Role $DB_USER found. Dropping it..."
      $prefix psql -c "DROP ROLE $DB_USER;"
    else
      echo "Role $DB_USER does not exist. Skipping drop."
    fi

# Take a snapshot of the database and original media files
[group('environment')]
save:
    ./scripts/take_snapshot.sh

# Dump the database, then restore it, and media, from the latest snapshot
[group('environment')]
load:
    ./scripts/load_snapshot.sh

# Sync the project's Python environment
[group('environment')]
init-python:
    uv sync --all-groups

# Sync the Python environment, allowing package upgrades
[group('environment')]
update-python:
    # just init-python --upgrade
    uv sync --all-groups --upgrade

# Install the project's Node environment
[group('environment')]
init-node:
    npm ci

# Update Node packages to the latest, respecting semver constraints
[group('environment')]
update-node:
    npm update --save

# Initialise the project's environment and database.
[group('environment')]
init:
    just init-python
    just init-node
    just db-init
    just dj migrate

# Update the Python & Node environments, and associated lock files
[group('environment')]
update:
    just update-python
    just update-node

### Linting

# Rewrite all OpenTofu config files into the canonical format
[group('lint')]
lint-tofu:
    @find infra/ -type f \( -name '*.tf' -o -name '*.tfvars' -o -name '*.tftest.hcl' \) -exec tofu fmt {} +

# Run Ruff linting and fix any auto-fixable issues
[group('lint')]
lint-python:
    @ruff check . --fix

# Format the Justfile (Note: Marked as 'Unstable!')
[group('lint')]
lint-just:
    @just --fmt --unstable

# Run `npx eslint .` (with Node warnings disabled)
[group('lint')]
lint-es:
    @NODE_NO_WARNINGS=1 npx eslint .

# Run all linting commands across the project
[group('lint')]
lint:
    just lint-tofu
    just lint-python
    just lint-es
    just lint-just

### Docker

# List the target images defined in the Dockerfile
[group('docker')]
_list-docker-targets:
    #!/usr/bin/env bash
    echo "Available targets:"
    grep -E '^FROM ' Dockerfile | awk '{target=$4; sub(/^hpk-/, "", target); print target}'

# Build a Docker image for hpk-(target), tagged with 'latest'
[group('docker')]
docker-build target='' tag='latest':
    #!/usr/bin/env bash
    [ -z "{{ target }}" ] && just _list-docker-targets && exit
    cmd="docker build --target hpk-{{ target }} -t hpk-{{ target }}:{{ tag }} ."
    echo $cmd && $cmd

# Run a transient Docker container built from a hpk-(target) image
[group('docker')]
docker-run target='' *command='bash':
    #!/usr/bin/env bash
    [ -z "{{ target }}" ] && just _list-docker-targets && exit
    cmd='docker run --rm -it hpk-{{ target }} {{ command }}'
    echo $cmd && $cmd

# Remove named volumes attached to the Docker Compose cluster
[group('docker')]
compose-clean:
    docker compose down -v

# Bring up the Docker Compose dev environment with existing images
[group('docker')]
compose-up:
    docker compose up

# Bring up the Docker Compose dev environment; build where needed
[group('docker')]
compose-build:
    docker compose up --build

# Bring up the Docker Compose dev environment; refresh volumes & build
[group('docker')]
compose-fresh:
    @just compose-clean
    @just compose-build

# Make and run Django migrations in the Docker Compose environment
[group('docker')]
compose-migrate:
    docker compose exec app-dev just migrate

### Editable package control

# Clone the upstream repositories of packages we want editable into lib/
[group('editables')]
clone-editables:
    #!/usr/bin/env bash
    mkdir -p lib
    {{ editables }}
    for repo in $repos; do
        repo_path="lib/$repo"
        upstream_url="${upstreams[$repo]}"
        origin_url="${origins[$repo]}"
        if [ -d "$repo_path/.git" ]; then
            echo "Repository '$repo' already exists at $repo_path. Skipping..."
            continue
        fi
        if [ -n "$upstream_url" ] || [ -n "$origin_url" ]; then
            clone_url=${upstream_url:-$origin_url}
            default_remote=${upstream_url:+upstream}
            default_remote=${default_remote:-origin}
            echo "Cloning $repo from $default_remote repo $clone_url..."
            git clone --origin "$default_remote" "$clone_url" "$repo_path"
            echo "Marking $repo_path as a safe directory..."
            git config --global --add safe.directory "$repo_path"
        else
            echo "Error: No upstream or origin remote defined for $repo" >&2
            exit 1
        fi
        [ -n "$upstream_url" ] && ! git -C "$repo_path" remote | grep -q '^upstream$' && {
            echo "Adding upstream remote for $repo: $upstream_url"
            git -C "$repo_path" remote add upstream "$upstream_url"
        }
        [ -n "$origin_url" ] && ! git -C "$repo_path" remote | grep -q '^origin$' && {
            echo "Adding origin remote for $repo: $origin_url"
            git -C "$repo_path" remote add origin "$origin_url"
        }
    done

# Checkout the version of an editable package read from uv.lock
[group('editables')]
set-editable-version package version='':
    #!/usr/bin/env bash
    package_path="lib/{{ package }}"
    if [ ! -d "$package_path" ]; then
      echo "Error: Package '$package_path' not found. Did you clone it into 'lib/'?" >&2
      exit 1
    fi
    if [ -n "{{ version }}" ]; then
        version="{{ version }}"
    else
        version=$(awk '\
           /^\[\[package\]\]/ { in_package = 0 }\
           $1 == "name" && $3 == "\"{{ package }}\"" { in_package = 1 }\
           in_package && $1 == "version" { gsub(/"/, "", $3); print $3; exit }\
        ' uv.lock)
        if [ -z "$version" ]; then
           echo "Error: Could not find version for package '{{ package }}' in 'uv.lock'." >&2
           exit 1
        fi
        echo "Found version $version for package '{{ package }}'."
    fi
    cd "$package_path"
    git fetch upstream --tags
    tag_name=$(git tag | grep -E "^v?$version$" || echo "")
    if [ -z "$tag_name" ]; then
        echo "Error: Neither '$version' nor 'v$version' tag exists for '{{ package }}'." >&2
        exit 1
    fi
    branch_name="v$version"
    if [ "$(git branch --list "$branch_name" | wc -l)" -gt 0 ]; then
        echo "Branch '$branch_name' already exists. Checking it out..."
        git checkout "$branch_name"
    else
        echo "Creating and checking out branch '$branch_name' from tag '$tag_name'..."
        git checkout -b "$branch_name" "$tag_name"
    fi
    echo "Package '{{ package }}' is now set to editable version $version on branch '$branch_name'."

# Set all checked-out editable repos to the version in uv.lock
[group('editables')]
set-editable-versions:
    #!/usr/bin/env bash
    {{ editables }}
    for repo in $repos; do
        if [ -d ./lib/$repo ]; then
            just set-editable-version $repo
        fi
    done

# Install a single repository checked out under lib/ as "editable"
[group('editables')]
install-editable package:
    #!/usr/bin/env bash
    package={{ package }}
    {{ editables }}
    repo_path="lib/$package"
    if [ ! -d "$repo_path" ]; then
        echo "Error: Package '$package' not found in 'lib/'. Did you clone it first?" >&2
        exit 1
    fi
    uv pip uninstall "$package"
    pre_install_function="pre_install_$package"
    if declare -f "$pre_install_function" > /dev/null; then
        echo "Running pre-install steps for $package in $repo_path..."
        (cd "$repo_path" && "$pre_install_function")
    fi
    package_extras="${extras[$package]:-}"
    if [ -n "$package_extras" ]; then
        echo "Installing $package with extras $package_extras..."
        uv pip install --config-settings editable_mode=strict -e "$package$package_extras @ ./$repo_path"
    else
        echo "Installing $package..."
        uv pip install --config-settings editable_mode=strict -e "$package @ ./$repo_path"
    fi
    post_install_function="post_install_$package"
    if declare -f "$post_install_function" > /dev/null; then
        echo "Running post-install steps for $package in $repo_path..."
        (cd "$repo_path" && "$post_install_function")
    fi
    if declare -f "finalise_install" > /dev/null; then
        echo "Running finalise_install..."
        finalise_install
    fi

# Install all repositories checked out under lib/ as "editable"
[group('editables')]
install-editables:
    #!/usr/bin/env bash
    {{ editables }}
    for repo in $repos; do
        if [ -d ./lib/$repo ]; then
            just install-editable $repo
        fi
    done

# Clone editables, set checkout versions in uv.lock, and install in .venv
[group('editables')]
init-editables:
    just clone-editables
    just set-editable-versions
    just install-editables

### Workflow

# Run runserver_plus, exposed to the world, on port 801
[group('workflow')]
_develop-local:
    just dj runserver_plus 0.0.0.0:8010

# Run a dev server with Docker Compose
[group('workflow')]
_develop-docker:
    just compose-up

# Run a dev server in the cloud
[group('workflow')]
_develop-cloud:
    just tofu-in dev apply

# Run a development server (local, docker, or cloud)
[group('workflow')]
dev target='local':
    @just _develop-{{ target }}

# Run an ssh command against the current workspace (or just ssh in)
[group('workflow')]
[no-exit-message]
ssh *args='':
    #!/usr/bin/env bash
    workspace=$(just -q tofu workspace show)
    just ssh-in $workspace "{{ args }}"

# Run ssh against the server for the specified environment
[group('workflow')]
[no-exit-message]
ssh-in env *args='':
    #!/usr/bin/env bash
    # args=({{ args }})
    server_ip=$(just -q tofu-in {{ env }} output server_ip 2> /dev/null)
    if [ $(echo "$server_ip" | wc -l) -ne 1 ]; then
      echo "error: Could not determine server IP for {{ env }} environment." >&2
      exit 1
    fi
    ssh {{ user }}@$server_ip "{{ args }}"

# Copy files from the current workspace's server to local
[group('workflow')]
[no-exit-message]
scp-get source target='':
    #!/usr/bin/env bash
    workspace=$(just -q tofu workspace show)
    just scp-get-in "$workspace" "{{ source }}" "${target:-.}"

# Copy files from a specific workspace's server to local
[group('workflow')]
[no-exit-message]
scp-get-in env source target='':
    #!/usr/bin/env bash
    server_ip=$(just -q tofu-in "$env" output server_ip 2> /dev/null)
    if [ $(echo "$server_ip" | wc -l) -ne 1 ]; then
      echo "error: Could not determine server IP for $env environment." >&2
      exit 1
    fi
    scp "{{ user }}@${server_ip}:{{ source }}" "${target:-.}"

# Copy files from local to the current workspace's server
[group('workflow')]
[no-exit-message]
scp-put source target:
    #!/usr/bin/env bash
    workspace=$(just -q tofu workspace show)
    just scp-put-in "$workspace" "{{ source }}" "{{ target }}"

# Copy files from local to a specific workspace's server
[group('workflow')]
[no-exit-message]
scp-put-in env source target:
    #!/usr/bin/env bash
    server_ip=$(just -q tofu-in "$env" output server_ip 2> /dev/null)
    if [ $(echo "$server_ip" | wc -l) -ne 1 ]; then
      echo "error: Could not determine server IP for $env environment." >&2
      exit 1
    fi
    scp "{{ source }}" "{{ user }}@${server_ip}:{{ target }}"

# Build assets, collect them in /static, and watch for changes
[group('workflow')]
watch *mode='':
    #!/usr/bin/env bash
    mode="{{ mode }}"
    stage=${mode:+":$mode"}
    npm run watch:build$stage

# Build static assets for both environments, or whichever is specified
[group('workflow')]
build *mode='':
    #!/usr/bin/env bash
    mode="{{ mode }}"
    stage=${mode:+":$mode"}
    npm run build$stage

# Set the INTERNAL_IPS on the server to your current public IP
[group('workflow')]
[no-exit-message]
set-internal-ips env='':
    #!/usr/bin/env bash
    env=${env:-$(just -q tofu workspace show)}
    public_ip=$(curl -s http://checkip.amazonaws.com)
    if [ -z "$public_ip" ]; then
      echo "error: Could not fetch public IP." >&2
      exit 1
    fi
    echo "Setting INTERNAL_IPS=\"$public_ip\" on $env..."
    just ssh-in $env "\
      sudo sed -i '/^INTERNAL_IPS=/d' /etc/environment && \
      echo '\"INTERNAL_IPS=\\\"$public_ip\\\"\"' | sudo tee -a /etc/environment >/dev/null && \
      sudo systemctl restart gunicorn-hpk\
    "

# Generate a SECRET_KEY valud for Django
[group('workflow')]
make-secret_key:
    #!/usr/bin/env bash
    secret_key=$(LC_ALL=C tr -dc 'abcdefghijklmnopqrstuvwxyz0123456789!@$%^&*(-_=+)' < /dev/urandom | head -c 50)
    echo $secret_key

# Create a full "emergency" database dump at emergency_backup.dump
[group('workflow')]
make-emergency-dump:
    pg_dump -U wagtail -h localhost -Fc -f emergency_backup.dump hpkdb

# Load the "emergency" database dump, from emergency_backup.dump
[group('workflow')]
load-emergency-dump:
    pg_restore -U wagtail -h localhost -d hpkdb --clean --if-exists emergency_backup.dump

# Run basic checks and pre-commit across the project
[group('workflow')]
check:
    just dj check
    uv run pre-commit run --all-files

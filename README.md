# Ada's website @ hpk.io

Wherein I set up a little website, and learn a bunch of stuff as I go.

## History & architecture

This repository started life as a Wagtail-based blog & general CMS for the personal website I was
developing at [https://hpk.io/](https://hpk.io/). Circa January 2025 I forked most of the generic
"blog and CMS stuff" out into its own FLOSS package, [Picata](https://pypi.org/project/picata/).

What's left in this repository is:

- The main Django settings for the site
- A big [Just](https://just.systems)file for all your task-running needs
- OpenTofu config for deployment to [DigitalOcean](https://www.digitalocean.com)
  droplets, utilising:
  - One big [cloud-init](http://cloud-init.io) config for both development and production
  - [Gunicorn](https://gunicorn.org) under [nginx](https://nginx.org/en/) for WSGI & web serving
- The latest snapshot of the site's database and media files

## Quickstart

### Pre-requisites

#### Software

- [Just](https://just.systems), available via [Homebrew](https://brew.sh) and [most package managers](https://github.com/casey/just?tab=readme-ov-file#installation)
- [Docker](https://www.docker.com) if you want to run the Dockerised development cluster
- For deployment to DigitalOcean, set up [doctl](https://docs.digitalocean.com/reference/doctl/)
  with your credentials
- [OpenTofu](https://opentofu.org) (or [Terraform](https://www.terraform.io) might work) for
  deployment to the cloud
- [PostgreSQL](https://www.postgresql.org) if you want to use the local development server
- [UV](https://docs.astral.sh/uv/) for all things Python
- [Node.js](https://nodejs.org/en)/[NPM](https://www.npmjs.com) for all things front-end

#### Configuration files

Two configuration files required to build this site are _not_ included, and should be created
before attempting to build or delpoy any of the development environments —

`.env` (in the project root):

```
DEVELOPER=ada
TLD=hpk.io
TIMEZONE=Australia/Perth
DB_NAME=hpkdb
DB_USER=wagtail
ADMIN_DJANGO_USER=root
ADMIN_EMAIL_NAME=majordomo
```

- `DEVELOPER` sets such things as:
  - The username used by ssh & scp in Justfile recipes
- Setting `TLD` will set up DNS A records on DigitalOcean:
  - Using just `TLD` for the 'prod' environment
  - Using `(env).for.TLD` for all other environments
- Admin emails will be set to `ADMIN_EMAIL_NAME@TLD`

and `infra/secrets.tfvars`

```
do_token          = "dop_v1_[your_DigitalOcean_API_token]"
ssh_fingerprint   = "[fingerprint_for_your_SSH_key_from_DigitalOcean_Settings]"
admin_password    = "[default_Django_superuser_password]"
db_password       = "[default_PostgreSQL_user_password]"
snapshot_password = "[password_for_GPG_encrypted_auth_user_tables_in_snapshots]"
gmail_password    = "[app_specific_Gmail_password_to_send_email_from_Django]"
secret_key        = "[Django_secret_key;make_one_with:`just make-secret-key`]"
```

### Deploying development environments

#### Local development

```shell
just init
```

This is also the command used to re-initialise the environment (you can clean
with `just scorch`), when you're in the `/app` directory, ssh'd into any server
deployed to the cloud. It will:

- Initialise the Python and Node environments for development
- Create a database named for `DB_NAME`, and
  - Add the `DB_USER` role with `DB_PASSWORD`
  - Load the latest site snapshot (database schemas, content, and media files)
  - Run any pending Django migrations

```shell
just dev local  # Note: 'local' is the default and can be omitted
```

- Starts `runserver_plus` attached to `0.0.0.0`, on port `8010`.

#### Docker Compose

```shell
docker-compose up
```

Starts a cluster of Docker container services:

- `db-server` runs a PostgreSQL image
- `app-runserver` runs the `runserver_plus` instance, exposed on port `8060`
- `app-gunicorn` runs Gunicorn, running `hpk.wsgi:application`
- `web-server` run Nginx, proxying `app-gunicorn`, serving on port `8050`
- `db-migrator` runs `django-admin migrate` once `db-server` is available
- `bundler` runs a Webpack watcher, building all assets when sources change
- `collector` runs a `django-admin collectstatic` watcher with Watchdog

With this setup, you can interact with a production-like setup (as the wsgi
module defaults to using `hpk.settings.prod`) running through nginx and Gunicorn
by vising http://localhost:8050, or interact with a "full-debug-mode" site by
visiting http://localhost:8060, where
[Django Debug Toolbar](https://django-debug-toolbar.readthedocs.io/en/latest/)
and all the features of
[runserver_plus](https://django-extensions.readthedocs.io/en/latest/runserver_plus.html)
should be available - just call `docker attach app-runserver` and add
`breakpoint()`s to start interacting with a
[`pdb`](https://docs.python.org/3/library/pdb.html) shell.

#### In the cloud

Each 'environment' you deploy (e.g. 'dev'/'test/'staging'/'prod)) will create a
new OpenTofu workspace by the same name, so their configuration and state files
are handled separately.

```shell
just deploy dev
```

This runs `tofu apply` against the named environment (workspace), loading
default variables from `infra/settings.tfvars`, any variables OpenTofu requires
from `.env` (which are written to `infra/dot_env.tfvars`), and any _override_
variables defined in `infra/envs/(env).tfvars` into the configuration.

`infra/envs/dev.tfvars`, for example, contains:

```
tags            = ["development"]
region          = "sgp1"
gunicorn_config = "gunicorn-dev.service.ini"
droplet_size    = "s-4vcpu-8gb"
uv_no_sync      = true
```

… to tag the box 'development', use a server farm closer to me, use a Gunicorn
config with debug logging enabled, and commission a much larger box than the one
used in production (becuase running VSCode, and runserver*plus, with mypy
analysing not just the project but any packages installed as editables, which
usually includes Django, can take up \_quite* a lot of memory…)

##### cloud-init

Cloud servers are bootstrapped with the `config/cloud-init.yml` configuration.
It will (among other things):

- Install necessary (and useful) system packages and configuration
- Write variables the app uses to `/etc/environment`
- Install [fail2ban](https://fail2ban.readthedocs.io/) with a basic configuration for a web server
- Create a 'wagtail' user, to own and run the application and database
- Create a user for the developer, add their SSH keys, install dotfiles, set groups, etc.
- Install Just, Node, and UV using their official sites' installers
- Clone the project to `/app`, making it owned by wagtail but group-writable
- Bootstrap the pre-commit hook environments
- Install the project's Python and Node dependencies
- Create the database, load the latest snapshot, and run migrations
- Build artifacts and collect static files appropraitely
- Use LetsEncrypt/certbot to get SSL certificates (using `--staging` unless in 'prod')
- Configure and start Gunicorn to run the app
- Configure and start nginx to serve the app over https

##### Sshing in

```shell
just ssh  # or `just ssh-in (env)`
```

This will get the IP of the box for the current `tofu` workspace (set this with
`just tofu workspace select (env)` and ssh in with the username set by `DEVELOPER`,
above (in case DNS has flushed through yet; for most purposes you can use the
`(env).for.TLD` A record set by `just deploy`.

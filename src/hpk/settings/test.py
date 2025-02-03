"""Django settings for test environments."""

# ruff: noqa: F405 ERA001
# mypy: disable-error-code="index"
# pyright: reportCallIssue=false, reportArgumentType=false

import logging

from .base import *  # noqa: F403  # noqa: F403

# NB: The logging system isn't set up yet; this is the "root" logger, which'll just write to stderr
logger = logging.getLogger()


# Ensure we're in test mode
DEBUG = True
TESTING = True

ALLOWED_HOSTS += ["testserver"]

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = "django-insecure-9yz$rw8%)1wm-l)j6q-r&$bu_n52sv=4q6)c5u8n10+5w+anec"  # noqa: S105

# Default to an in-memory Sqlite database, or use a file or PostgreSQL on request
test_db = getenv("HPK_TEST_DB", "memory")
if test_db.startswith("postgres"):
    raise NotImplementedError("PostgreSQL not yet supported for tests.")
else:
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": ":memory:" if test_db == "memory" else str(BASE_DIR / test_db),
        }
    }

logger.warning(f"Loading hpk.settings.test…\nDATABASES = {DATABASES}")


if getenv("DJANGO_MANAGEMENT_COMMAND", "").startswith(("shell", "runserver")):
    INSTALLED_APPS += [
        "django_extensions",
    ]

    SHELL_PLUS_IMPORTS = ["from hpk.tests import fixtures"]

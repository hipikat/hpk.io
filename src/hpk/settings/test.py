"""Django settings for test environments."""

from .base import *  # noqa: F403

# Ensure we're in test mode
DEBUG = False
TESTING = True

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = "django-insecure-9yz$rw8%)1wm-l)j6q-r&$bu_n52sv=4q6)c5u8n10+5w+anec"  # noqa: S105

# Use SQLite for speed during testing
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": ":memory:",  # Fastest way to run tests
    }
}

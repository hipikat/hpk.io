# ruff: noqa: F405 ERA001
"""Django settings for development environments."""

import logging

from .base import *  # noqa: F403

# NB: The logging system isn't set up yet; this is the "root" logger, which'll just write to stderr
logger = logging.getLogger()

DEBUG = True
USE_X_FORWARDED_HOST = True


# Security
SECRET_KEY = "django-insecure-9yz$rw8%)1wm-l)j6q-r&$bu_n52sv=4q6)c5u8n10+5w+anec"  # noqa: S105

CLASS_C_NETWORK_ADDR = ["192.168.1.188"]
CLASS_C_DEVICE_ADDRS = [*CLASS_C_NETWORK_ADDR, "192.168.1.152", "192.168.1.240"]

INTERNAL_IPS = [*getenv("INTERNAL_IPS", "").split(), "localhost", "127.0.0.1"]
with contextlib.suppress(Exception):
    public_ip = get_public_ip()
    if public_ip:
        INTERNAL_IPS.append(str(public_ip))

INTERNAL_IPS += CLASS_C_DEVICE_ADDRS
ALLOWED_HOSTS += CLASS_C_NETWORK_ADDR

# logger.warning(
#     "Loading hpk.settings.dev…\n"
#     "INTERNAL_IPS = {INTERNAL_IPS}\nALLOWED_HOSTS = {ALLOWED_HOSTS}"
# )

# Create staticfiles.json manifest and hashed files when collecting static files
if getenv("DJANGO_MANAGEMENT_COMMAND") == "collectstatic":
    STORAGES["staticfiles"]["BACKEND"] = (
        "django.contrib.staticfiles.storage.ManifestStaticFilesStorage"
    )


# Enable Django Debug Toolbar and runserver_plus
INSTALLED_APPS += [
    "debug_toolbar",
    "django_extensions",
]
MIDDLEWARE = ["debug_toolbar.middleware.DebugToolbarMiddleware", *MIDDLEWARE]


# Logging (tuned for debugging)
LOGGING["handlers"]["console"]["level"] = "DEBUG"

LOGGING["root"]["level"] = "DEBUG"

LOGGING["loggers"]["gunicorn"] = {
    "handlers": ["console"],
    "level": "INFO",
    "propagate": False,
}

LOGGING["loggers"]["hpk"]["level"] = "DEBUG"

LOGGING["loggers"]["django"]["level"] = "DEBUG"
LOGGING["loggers"]["django.db.backends"] = {"level": "INFO"}
LOGGING["loggers"]["django.template"]["level"] = "INFO"
LOGGING["loggers"]["django.request"]["level"] = "DEBUG"
LOGGING["loggers"]["django.request"]["handlers"] += ["console"]
LOGGING["loggers"]["django.utils"] = {"level": "INFO"}

LOGGING["loggers"]["wagtail"]["level"] = "DEBUG"

LOGGING["loggers"]["asyncio"] = {"level": "INFO"}

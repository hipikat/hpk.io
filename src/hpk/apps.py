"""Application configuration for the hpk Django app."""

from django.apps import AppConfig


class Config(AppConfig):
    """Configuration class for the hpk Django application."""

    default_auto_field = "django.db.models.BigAutoField"
    name = "hpk"

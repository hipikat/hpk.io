"""Default imports for django-extensions's shell_plus command, for dev and test."""

SHELL_PLUS_IMPORTS = [
    "from hpk.tests import fixtures",
    "from picata.helpers.wagtail import page_preview_data, visible_pages_qs",
]

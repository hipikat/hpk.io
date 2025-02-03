"""Test all settings modules."""

import importlib
import os

import pytest


@pytest.mark.xdist_group(name="settings")
def test_dev_settings() -> None:
    """Test dev settings."""
    from hpk.settings import dev

    importlib.reload(dev)
    assert dev.DEBUG


@pytest.mark.xdist_group(name="settings")
def test_dev_settings_runserver() -> None:
    """Test dev settings when calling runserver."""
    from hpk.settings import dev

    os.environ["DJANGO_MANAGEMENT_COMMAND"] = "runserver"
    importlib.reload(dev)
    assert "debug_toolbar" in dev.INSTALLED_APPS
    assert dev.MIDDLEWARE.index("debug_toolbar.middleware.DebugToolbarMiddleware") == 0


@pytest.mark.xdist_group(name="settings")
def test_dev_settings_collectstatic() -> None:
    """Test dev settings contains `ManifestStaticFilesStorage` when running collectstatic."""
    from hpk.settings import dev

    os.environ["DJANGO_MANAGEMENT_COMMAND"] = "collectstatic"
    importlib.reload(dev)
    assert (
        "django.contrib.staticfiles.storage.ManifestStaticFilesStorage"
        in dev.STORAGES["staticfiles"]["BACKEND"]
    )


@pytest.mark.xdist_group(name="settings")
def test_mypy_settings() -> None:
    """Test mypy can be imported without throwing an exception."""
    try:
        module = importlib.import_module("hpk.settings.mypy")
    except (ModuleNotFoundError, ImportError) as e:
        pytest.fail(f"Importing hpk.settings.mypy failed: {e}")

    assert isinstance(module, object), "Module was not properly imported."


@pytest.mark.xdist_group(name="settings")
def test_prod_settings() -> None:
    """Test production settings."""
    from hpk.settings import prod

    assert (
        "django.contrib.staticfiles.storage.ManifestStaticFilesStorage"
        in prod.STORAGES["staticfiles"]["BACKEND"]
    )


@pytest.mark.xdist_group(name="settings")
def test_postgres_testing_not_supported() -> None:
    """Ensure test settings raise NotImplementedError when using PostgreSQL."""
    with pytest.raises(NotImplementedError, match="PostgreSQL not yet supported for tests."):  # noqa: PT012
        from hpk.settings import test

        os.environ["HPK_TEST_DB"] = "postgres"
        importlib.reload(test)


@pytest.mark.xdist_group(name="settings")
@pytest.mark.parametrize("command", ["shell", "runserver"])
def test_test_settings_commands_install_extensions(command: str) -> None:
    """Ensure 'django_extensions' added to INSTLLED_APPS when running shell or runserver."""
    from hpk.settings import test

    os.environ["HPK_TEST_DB"] = "memory"
    os.environ["DJANGO_MANAGEMENT_COMMAND"] = command
    importlib.reload(test)
    assert "django_extensions" in test.INSTALLED_APPS

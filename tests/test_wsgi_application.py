"""Tests for hpk's WSGI configuration."""


def test_wsgi_application_import() -> None:
    """Ensure that WSGI application can be imported without error."""
    import hpk.wsgi

    assert hasattr(hpk.wsgi, "application")

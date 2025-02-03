"""Test the landing page response as expected, to an actual test client."""

from http import HTTPStatus

import pytest
from django.test import Client

from hpk.tests import fixtures


@pytest.mark.django_db
def test_default_homepage_contains_welcome() -> None:
    """Test that the homepage contains the expected welcome message."""
    client = Client()
    response = client.get("/")
    assert response.status_code == HTTPStatus.OK
    assert "Welcome to your new Wagtail site!" in response.content.decode()


@pytest.mark.django_db
def test_test_site_homepage_contains_home_and_hpkio() -> None:
    """Test that the `setup_test_site` fixture function creates the expected home page."""
    fixtures.setup_test_site()
    client = Client()
    response = client.get("/")
    assert response.status_code == HTTPStatus.OK
    content = response.content.decode()
    assert "Home" in content
    assert "hpk.io" in content

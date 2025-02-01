"""Pytest configuration and shared fixtures for hpk's test suite."""

# ruff: noqa: ARG001

import pytest
from django.core.management import call_command
from picata.models import Article, HomePage, PostGroupPage
from pytest import FixtureRequest  # noqa: PT013
from wagtail.models import Site


@pytest.fixture(scope="session")
def django_db_setup() -> None:
    """Ensure the test database is migrated before any tests run."""
    call_command("migrate")


@pytest.fixture
def site_setup(db: FixtureRequest) -> dict[str, object]:
    """Creates a HomePage, sets it as root, and adds Blog and Articles."""
    root = HomePage.objects.create(title="Home", slug="home")
    site = Site.objects.get(is_default_site=True)
    site.root_page = root
    site.save()

    blog = PostGroupPage(title="Blog", slug="blog")
    root.add_child(instance=blog)

    article = Article(title="Test Article", slug="test-article")
    blog.add_child(instance=article)

    return {"home": root, "blog": blog, "article": article}

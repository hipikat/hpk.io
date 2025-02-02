"""Tests for Wagtail page creation rules in hpk using picata's models."""

# ruff: noqa: ANN001, S106

import pytest
from django.contrib.auth import get_user_model
from picata.models import Article, HomePage, PostGroupPage
from wagtail.test.utils import WagtailPageTestCase
from wagtail.test.utils.form_data import nested_form_data, rich_text, streamfield

from hpk.tests.fixtures import setup_test_site


@pytest.mark.django_db
class TestWagtailPages(WagtailPageTestCase):
    """Test suite for verifying allowed and disallowed Wagtail page structures."""

    @classmethod
    def setUpTestData(cls) -> None:
        """Set up basic site structure and create a test superuser."""
        cls.site_data = setup_test_site()

        # Create a test superuser (user: testadmin, pass: testpassword)
        User = get_user_model()  # noqa: N806
        cls.test_user = User.objects.create_superuser(  # type: ignore[reportAttributeAccessIssue]
            username="testadmin",
            email="testadmin@example.com",
            password="testpassword",
        )

    def setUp(self) -> None:
        """Log in the test superuser before each test."""
        self.client.login(username="testadmin", password="testpassword")

    def test_postgroup_can_be_created_under_home(self) -> None:
        """Ensure a PostGroupPage can be created directly under HomePage."""
        home: HomePage = self.site_data["home"]
        self.assertCanCreate(
            home,
            PostGroupPage,
            nested_form_data({"title": "Test Post-Listing Page", "slug": "test-post-list"}),
        )

    def test_article_can_be_created_under_postgroup(self) -> None:
        """Ensure an Article page can be created under a PostGroupPage."""
        blog: PostGroupPage = self.site_data["blog"]
        self.assertCanCreate(
            blog,
            Article,
            nested_form_data(
                {
                    "title": "Test Article",
                    "slug": "another-test-article",
                    "content": streamfield(
                        [("rich_text", rich_text("<p>This is a test article.</p>"))]
                    ),
                }
            ),
        )

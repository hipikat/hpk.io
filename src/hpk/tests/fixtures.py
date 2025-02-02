"""Functions to be used as test fixtures; defined here for reusability."""

from typing import TypedDict, cast

from picata.models import Article, HomePage, PostGroupPage
from wagtail.models import Page, Site


class TestSiteContext(TypedDict):
    """Context returned from the `setup_test_site` function."""

    home: HomePage
    blog: PostGroupPage
    article: Article


def setup_test_site() -> TestSiteContext:
    """Creates a HomePage, sets it as root, and adds Blog and Articles."""
    home = HomePage(title="Home", slug="root")
    wagtail_root = cast(Page, Page.get_first_root_node())
    wagtail_root.add_child(instance=home)

    site = Site.objects.get(is_default_site=True)
    site.root_page = home
    site.save()

    blog = PostGroupPage(title="Blog", slug="blog", show_in_menus=True)
    home.add_child(instance=blog)

    article = Article(title="Test Article", slug="test-article")
    blog.add_child(instance=article)

    return {"home": home, "blog": blog, "article": article}

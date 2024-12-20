"""Template tags for rendering menus."""

# NB: Wagtail hasn't typed QuerySet[Page] as containing `specific`, circa 2024-12-20
# pyright: reportAttributeAccessIssue=false

from typing import TypedDict

from django import template
from django.http import HttpRequest
from wagtail.models import Page
from wagtail.models.sites import Site

from hpk.typing import TemplateContext

register = template.Library()


class SiteMenuContext(TypedDict):
    """Context returned from `render_site_menu` for `site_menu.html`."""

    root_page: Page
    menu_pages: list[Page]
    request: HttpRequest


@register.inclusion_tag("tags/site_menu.html", takes_context=True)
def render_site_menu(context: TemplateContext) -> SiteMenuContext:
    """Fetch the site root and its child pages for the site menu."""
    request: HttpRequest = context["request"]
    current_site = Site.find_for_request(request)
    if not current_site:
        raise ValueError("No Wagtail Site found for the current request.")

    root_page = current_site.root_page.specific

    if request.user.is_authenticated:
        menu_pages = root_page.get_children().specific()
    else:
        menu_pages = root_page.get_children().live().specific()

    return {
        "root_page": root_page,
        "menu_pages": menu_pages,
        "request": request,
    }

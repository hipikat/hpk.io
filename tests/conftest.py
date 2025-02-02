"""Pytest configuration and shared fixtures for hpk's test suite."""

# ruff: noqa: ARG001

import pytest
from pytest import FixtureRequest  # noqa: PT013

from hpk.tests.fixtures import TestSiteContext, setup_test_site


@pytest.fixture
def site_setup(db: FixtureRequest) -> TestSiteContext:
    """Creates a HomePage, sets it as root, and adds Blog and Articles."""
    return setup_test_site()

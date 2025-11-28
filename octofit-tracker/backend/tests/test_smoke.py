"""Simple pytest smoke tests for OctoFit backend.
These tests are intentionally lightweight so CI can give fast feedback.
"""

import importlib


def test_django_import_and_version():
    """Verify Django imports and provides a version string."""
    django = importlib.import_module("django")
    ver = django.get_version()
    assert isinstance(ver, str) and ver.count('.') >= 1


def test_rest_framework_and_pymongo_import():
    """Verify that core packages import cleanly (rest_framework, pymongo)."""
    rest_framework = importlib.import_module("rest_framework")
    pymongo = importlib.import_module("pymongo")

    # quick sanity checks
    assert hasattr(rest_framework, '__name__')
    assert hasattr(pymongo, 'MongoClient')

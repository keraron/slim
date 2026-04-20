"""MkDocs hooks: SSL for include-markdown, and nav from docs/.index."""

import ssl
import certifi
from pathlib import Path


def on_startup(**kwargs):
    """Configure SSL context to use certifi certificates."""
    import urllib.request

    ssl_context = ssl.create_default_context(cafile=certifi.where())
    https_handler = urllib.request.HTTPSHandler(context=ssl_context)
    opener = urllib.request.build_opener(https_handler)
    urllib.request.install_opener(opener)


def on_config(config, **kwargs):
    """Set config['nav'] from docs/.index (YAML with a top-level nav: list)."""
    try:
        import yaml
    except ImportError:
        return config

    index = Path(config["docs_dir"]).resolve() / ".index"
    if not index.is_file():
        return config

    data = yaml.safe_load(index.read_text(encoding="utf-8")) or {}
    nav = data.get("nav")
    if nav:
        config["nav"] = nav
    return config

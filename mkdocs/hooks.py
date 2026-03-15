"""MkDocs hooks to configure SSL certificates for include-markdown plugin."""
import json
import os
import ssl
import certifi

# Monkey patch urllib to use certifi's certificate bundle
def on_startup(**kwargs):
    """Configure SSL context to use certifi certificates."""
    import urllib.request
    
    # Create SSL context with certifi's certificate bundle
    ssl_context = ssl.create_default_context(cafile=certifi.where())
    
    # Set the default opener to use this context
    https_handler = urllib.request.HTTPSHandler(context=ssl_context)
    opener = urllib.request.build_opener(https_handler)
    urllib.request.install_opener(opener)


def on_post_build(config, **kwargs):
    """Write versions.json for local dev so the Material version selector has data."""
    version = os.environ.get("MIKE_DOCS_VERSION", "dev")
    versions = [
        {"version": version, "title": version, "aliases": ["latest"] if version == "dev" else []}
    ]
    path = os.path.join(config["site_dir"], "versions.json")
    with open(path, "w") as f:
        json.dump(versions, f, indent=2)


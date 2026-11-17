"""Reject release tags that do not match the committed app version."""
import os
import re
from pathlib import Path

version = re.search(r"^version:\s*(\d+\.\d+\.\d+)\+(\d+)\s*$", Path("pubspec.yaml").read_text(), re.MULTILINE)
if not version or int(version[2]) <= 0:
    raise SystemExit("pubspec.yaml needs version: X.Y.Z+N with a positive build number")
tag = os.environ["GITHUB_REF_NAME"]
if tag not in (f"android-v{version[1]}", f"ios-v{version[1]}"):
    raise SystemExit(f"Release tag {tag} does not match pubspec.yaml {version[0]}")
print(f"Verified {tag}, build {version[2]}")

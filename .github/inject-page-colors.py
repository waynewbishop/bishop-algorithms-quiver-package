"""Inject standardColorIdentifier into DocC JSON metadata.

DocC only sets this field when @PageColor is used in source.
This script adds it post-build based on page role so every
page gets the correct header accent color.
"""

import json
import glob
import sys

role_colors = {
    "collection": "blue",
    "collectionGroup": "purple",
    "article": "green",
    "symbol": "purple",
}

data_dir = sys.argv[1]
count = 0

for path in glob.glob(f"{data_dir}/**/*.json", recursive=True):
    try:
        with open(path) as f:
            data = json.load(f)
        meta = data.get("metadata", {})
        role = meta.get("role", "")
        color = role_colors.get(role)
        if color and "color" not in meta:
            meta["color"] = {"standardColorIdentifier": color}
            with open(path, "w") as f:
                json.dump(data, f, separators=(",", ":"))
            count += 1
    except (json.JSONDecodeError, KeyError):
        pass

print(f"Injected color into {count} JSON files")

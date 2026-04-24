#!/usr/bin/env python3
"""
Create a new video's code folder + symlink in one shot.

Usage:
    new_video.py "Protocols 6:5 - Example"         # slug inferred
    new_video.py "Protocols 6:5 - Example" --slug protocols-6-5-example
    new_video.py "Protocols 6:5 - Example" --youtube https://youtu.be/XXX --publish

Effects:
    - mkdir ~/Developer/stemfoxio-tutorials/<slug>/
    - append entry to codemap.yaml (publish: false unless --publish)
    - ln -s <abs slug path> ~/StemFoxIO/<folder>/Code
"""

from pathlib import Path
import argparse
import re
import sys
import yaml

REPO = Path(__file__).resolve().parent.parent
CODEMAP = REPO / "codemap.yaml"
STEMFOX = Path.home() / "StemFoxIO"


def slugify(s: str) -> str:
    s = s.lower().replace("&", "and")
    s = re.sub(r"[^a-z0-9]+", "-", s)
    return s.strip("-")


def main() -> int:
    p = argparse.ArgumentParser(description="Create a new tutorials slug folder + symlink.")
    p.add_argument("folder", help="StemFoxIO folder name, e.g. 'Protocols 6:5 - Example'")
    p.add_argument("--slug", help="Override the computed slug")
    p.add_argument("--youtube", default="", help="YouTube URL (optional)")
    p.add_argument("--publish", action="store_true", help="Set publish: true (default false)")
    args = p.parse_args()

    folder = args.folder
    slug = args.slug or slugify(folder)
    slug_dir = REPO / slug
    video_dir = STEMFOX / folder
    symlink = video_dir / "Code"

    if not video_dir.is_dir():
        print(f"error: {video_dir} does not exist", file=sys.stderr)
        return 1
    if slug_dir.exists():
        print(f"error: {slug_dir} already exists", file=sys.stderr)
        return 1
    if symlink.exists() or symlink.is_symlink():
        print(f"error: {symlink} already exists", file=sys.stderr)
        return 1

    data = yaml.safe_load(CODEMAP.read_text()) or {}
    videos = data.get("videos") or []
    if any(v.get("slug") == slug for v in videos):
        print(f"error: slug '{slug}' already in codemap.yaml", file=sys.stderr)
        return 1

    slug_dir.mkdir(parents=True)
    symlink.symlink_to(slug_dir)

    videos.append({
        "slug": slug,
        "folder": folder,
        "youtube": args.youtube,
        "publish": bool(args.publish),
    })
    data["videos"] = videos
    CODEMAP.write_text(yaml.safe_dump(data, sort_keys=False))

    print(f"created {slug_dir}")
    print(f"symlinked {symlink} -> {slug_dir}")
    print(f"added entry to {CODEMAP}")
    print(f"next: drop playground/project into {slug_dir}, add README.md, then run scripts/gen_readme.py")
    return 0


if __name__ == "__main__":
    sys.exit(main())

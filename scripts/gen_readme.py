#!/usr/bin/env python3
"""
Regenerate README.md at the repo root from codemap.yaml.
Lists every entry with publish: true.
"""

from pathlib import Path
import sys
import yaml

REPO = Path(__file__).resolve().parent.parent
CODEMAP = REPO / "codemap.yaml"
README = REPO / "README.md"

HEADER = """# StemFoxIO Tutorials

Sample code for [StemFoxIO](https://www.youtube.com/@StemFoxIO) — iOS/Swift video tutorials.

Each folder below corresponds to one video. Clone the repo and open the playground or Xcode project for the video you're watching.

```bash
git clone https://github.com/joshuabryson/stemfoxio-tutorials.git
```

## Videos

"""

FOOTER = """
## License

MIT. Use the code however you like for learning or your own projects.
"""


def title_from_folder(folder: str) -> str:
    return folder.strip()


def main() -> int:
    if not CODEMAP.exists():
        print(f"error: {CODEMAP} not found", file=sys.stderr)
        return 1

    data = yaml.safe_load(CODEMAP.read_text()) or {}
    videos = data.get("videos") or []
    published = [v for v in videos if v.get("publish")]

    lines = [HEADER]
    if not published:
        lines.append("_No videos published yet._\n")
    else:
        lines.append("| Video | Code | Watch |")
        lines.append("| --- | --- | --- |")
        for v in published:
            title = title_from_folder(v["folder"])
            slug = v["slug"]
            yt = v.get("youtube", "").strip()
            watch = f"[YouTube]({yt})" if yt else "—"
            lines.append(f"| {title} | [`{slug}/`](./{slug}) | {watch} |")
        lines.append("")
    lines.append(FOOTER)

    README.write_text("\n".join(lines))
    print(f"wrote {README} ({len(published)} published)")
    return 0


if __name__ == "__main__":
    sys.exit(main())

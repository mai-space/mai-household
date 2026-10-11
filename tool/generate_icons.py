"""Erzeugt App-Icon (Android, iOS) und In-App-Logo aus einer Vorlage.

    pip install cairosvg pillow && python3 tool/generate_icons.py

Motiv: weißes Haus mit Haken (Zuhause + „erledigt“) auf dem grünen
Markenverlauf — gleiche Bildsprache wie Mai Doctor Hub.
"""

import io
import json
from pathlib import Path

import cairosvg

ROOT = Path(__file__).resolve().parent.parent
RES = ROOT / "android/app/src/main/res"

SEED = "#3E7C59"
ACCENT = "#6BAF7F"

# 108×108 = Android-Adaptive-Icon-Raster; Motiv bleibt in der 66er-Schutzzone.
HOUSE = """
  <polygon points="54,27 82,51 26,51" fill="{c}" stroke="{c}"
           stroke-width="5" stroke-linejoin="round"/>
  <rect x="33" y="46" width="42" height="36" rx="5" fill="{c}"/>
"""
CHECK = """
  <path d="M43 64.5l7.5 7.5L66 56.5" fill="none" stroke="{c}"
        stroke-width="6.5" stroke-linecap="round" stroke-linejoin="round"/>
"""
BACKGROUND = f"""
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="{ACCENT}"/>
      <stop offset="1" stop-color="{SEED}"/>
    </linearGradient>
  </defs>
"""


def svg(body, view="0 0 108 108"):
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{view}">{body}</svg>'
    )


MOTIF = HOUSE.format(c="#fff") + CHECK.format(c=SEED)
FOREGROUND = svg(MOTIF)
# Volles Bild (Legacy-Icon, Logo): abgerundetes Quadrat + Motiv.
ROUNDED = svg(
    BACKGROUND
    + '<rect x="14" y="14" width="80" height="80" rx="20" fill="url(#bg)"/>'
    + MOTIF,
    view="14 14 80 80",
)
# iOS: vollflächig, engerer Ausschnitt (keine 66er-Schutzzone nötig).
IOS = svg(
    BACKGROUND + '<rect width="108" height="108" fill="url(#bg)"/>' + MOTIF,
    view="20 20 68 68",
)


def png(source, path, size):
    path.parent.mkdir(parents=True, exist_ok=True)
    cairosvg.svg2png(
        bytestring=source.encode(),
        write_to=str(path),
        output_width=size,
        output_height=size,
    )


def monochrome(path, size):
    """Themed Icons (Android 13+) nutzen nur Alpha: Haus deckend, Haken
    ausgespart (SVG-Masken rendert cairosvg nicht zuverlässig)."""
    from PIL import Image, ImageChops

    def alpha(body):
        data = cairosvg.svg2png(
            bytestring=svg(body).encode(), output_width=size, output_height=size
        )
        return Image.open(io.BytesIO(data)).convert("RGBA").split()[3]

    house = alpha(HOUSE.format(c="#fff"))
    check = alpha(CHECK.format(c="#fff"))
    mask = ImageChops.subtract(house, check)
    out = Image.new("RGBA", (size, size), (255, 255, 255, 0))
    out.putalpha(mask)
    path.parent.mkdir(parents=True, exist_ok=True)
    out.save(path, optimize=True)


def ios_icons():
    """iOS-AppIcon ohne Alphakanal (App Store lehnt Transparenz ab)."""
    from PIL import Image

    folder = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    contents = json.loads((folder / "Contents.json").read_text())
    for image in contents["images"]:
        name = image.get("filename")
        if not name:
            continue
        points = float(image["size"].split("x")[0])
        size = round(points * int(image["scale"].rstrip("x")))
        data = cairosvg.svg2png(
            bytestring=IOS.encode(), output_width=size, output_height=size
        )
        rgba = Image.open(io.BytesIO(data)).convert("RGBA")
        flat = Image.new("RGB", rgba.size, SEED)
        flat.paste(rgba, mask=rgba.split()[3])
        flat.save(folder / name, optimize=True)


def main():
    (ROOT / "assets/branding/logo.svg").write_text(ROUNDED + "\n")

    densities = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}
    for name, factor in densities.items():
        folder = RES / f"mipmap-{name}"
        png(ROUNDED, folder / "ic_launcher.png", round(48 * factor))
        png(FOREGROUND, folder / "ic_launcher_foreground.png", round(108 * factor))
        monochrome(folder / "ic_launcher_monochrome.png", round(108 * factor))

    for scale, suffix in [(1, ""), (2, "2.0x/"), (3, "3.0x/")]:
        png(ROUNDED, ROOT / f"assets/branding/{suffix}logo.png", 96 * scale)

    ios_icons()


if __name__ == "__main__":
    main()

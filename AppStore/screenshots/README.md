# Screenshots

- `iphone-*.png` — iPhone 17 Pro Max simulator (6.9", 1320×2868), captured with `xcrun simctl io <udid> screenshot`. Upload under "iPhone 6.9" Display"; App Store Connect reuses them for smaller sizes.
- `mac-*.png` — must be 2880×1800 (or 1280×800 / 1440×900 / 2560×1600). Take the window with Cmd+Shift+4, Space, click the Stayawake window (saves to Desktop), then pad to size:

```
python3 - <<'EOF2'
from PIL import Image
src = Image.open("/path/to/Screenshot.png").convert("RGBA")
bg = Image.new("RGBA", (2880, 1800), (12, 18, 34, 255))
bg.paste(src, ((2880 - src.width) // 2, (1800 - src.height) // 2), src)
bg.convert("RGB").save("mac-1-on.png")
EOF2
```

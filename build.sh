#!/bin/bash
# Builds StayAwake.app into ./build. Requires Xcode command line tools.
set -euo pipefail
cd "$(dirname "$0")"

APP=build/StayAwake.app
rm -rf build
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

echo "Compiling…"
swiftc -O -parse-as-library StayAwake.swift -o "$APP/Contents/MacOS/StayAwake"

echo "Rendering icon…"
mkdir -p AppIcon.iconset
swift makeicon.swift
cd AppIcon.iconset
mv icon_16.png icon_16x16.png;   mv icon_32.png icon_16x16@2x.png
cp icon_16x16@2x.png icon_32x32.png; mv icon_64.png icon_32x32@2x.png
mv icon_128.png icon_128x128.png; mv icon_256.png icon_128x128@2x.png
cp icon_128x128@2x.png icon_256x256.png; mv icon_512.png icon_256x256@2x.png
cp icon_256x256@2x.png icon_512x512.png; mv icon_1024.png icon_512x512@2x.png
cd ..
iconutil -c icns AppIcon.iconset -o "$APP/Contents/Resources/AppIcon.icns"
rm -rf AppIcon.iconset

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key><string>StayAwake</string>
    <key>CFBundleIdentifier</key><string>com.gustav.stayawake</string>
    <key>CFBundleName</key><string>StayAwake</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleShortVersionString</key><string>1.1</string>
    <key>CFBundleIconFile</key><string>AppIcon</string>
    <key>LSMinimumSystemVersion</key><string>13.0</string>
</dict>
</plist>
PLIST

codesign -fs - "$APP"
echo "Built $APP — install with: cp -R $APP /Applications/"

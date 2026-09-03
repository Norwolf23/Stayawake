# Stayawake ☕️

A tiny macOS menu bar app that keeps your Mac awake. One click on, one click off. No settings, no windows, no dependencies — ~60 lines of Swift using IOKit power assertions.

- ☕️ Coffee-cup icon in the menu bar — filled when active, outlined when off
- Prevents system sleep and display sleep while active (also with the lid closed on AC)
- Shows in the Dock with a running indicator like a normal app
- Cleans up after itself: quitting the app always releases the sleep lock

## Build

Requires macOS 13+, Xcode and [xcodegen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`).

```sh
git clone https://github.com/Norwolf23/Stayawake.git
cd Stayawake
xcodegen generate && xcodebuild -scheme Stayawake -configuration Release build
```

The app is sandboxed and signed for the Mac App Store; archive in Xcode (Product → Archive) and export with `ExportOptions.plist` to submit.

Optional: add it to System Settings → General → Login Items to start it at login.

## How it works

The toggle creates two IOKit power assertions (`PreventUserIdleDisplaySleep` + `PreventSystemSleep`, the same ones `caffeinate -dis` uses) and releases them when you toggle off or quit. `check_assertion.swift` verifies they show up in `pmset`.

Check what's keeping your Mac awake at any time with:

```sh
pmset -g assertions
```

## License

MIT

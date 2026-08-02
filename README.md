# StayAwake ☕️

A tiny macOS menu bar app that keeps your Mac awake. One click on, one click off. No settings, no windows, no dependencies — ~50 lines of Swift wrapping the built-in `caffeinate` tool.

- ☕️ Coffee-cup icon in the menu bar — filled when active, outlined when off
- Prevents system sleep, display sleep, and disk idle while active
- Shows in the Dock with a running indicator like a normal app
- Cleans up after itself: quitting the app always releases the sleep lock

## Install

Requires macOS 13+ and Xcode command line tools (`xcode-select --install`).

```sh
git clone https://github.com/Norwolf23/StayAwake.git
cd StayAwake
./build.sh
cp -R build/StayAwake.app /Applications/
open /Applications/StayAwake.app
```

Optional: add it to System Settings → General → Login Items to start it at login.

## How it works

The toggle runs `/usr/bin/caffeinate -dimsu` as a child process and terminates it when you toggle off or quit. That's the entire trick — macOS already ships the sleep-prevention tool; this just gives it a menu bar switch.

Check what's keeping your Mac awake at any time with:

```sh
pmset -g assertions
```

## License

MIT

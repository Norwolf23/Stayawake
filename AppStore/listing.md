# Stayawake — App Store listing

Everything below is paste-ready for App Store Connect. Same text for iOS and macOS unless marked.

## Name
Stayawake

## Subtitle (30 chars max)
Keep the screen on. One tap.

## Promotional text (170 chars max)
One tap keeps your Mac or iPhone awake, with a timer so you never forget to switch it back. Now with a Siri shortcut: "Keep my screen on with Stayawake."

## Description
Stayawake keeps your screen on for as long as you need, then gets out of the way.

Tap the cup. Pick 30 minutes, 1 hour, 2 hours, or until you turn it off. The cup fills, steam rises, and your screen stays awake. Tap again and everything goes back to normal.

ON THE MAC
• Lives in the menu bar as a coffee cup. Click it to start or stop.
• Stops idle sleep, display sleep and lid-open system sleep while active.
• Shows how long you've been awake and how long is left.
• Always releases the lock when you quit, so it never leaves your Mac stuck awake.
• Note: closing the lid still puts the Mac to sleep unless an external display is connected. That is a macOS rule, not something any app can override.

ON THE iPHONE
• Perfect for workouts, recipes, reading music, or following instructions: prop the phone up and the screen stays on while Stayawake is open.
• A big stopwatch, the time, battery level and time left, so the lit-up screen is useful.
• Dim screen button drops brightness to save battery while staying awake. Tap to brighten.
• "Hey Siri, keep my screen on with Stayawake" starts it hands-free. Also available as a Shortcuts action with a duration, so you can automate it (arrive at the gym, screen stays on).
• iOS keeps the screen on only while an app is in the foreground. Stayawake makes that one tap instead of digging through Settings, and switches itself off so your battery is safe.

No accounts. No ads. No tracking. No network access. It does one thing and does it well.

## Keywords (100 chars max, comma separated)
keep awake,screen on,caffeine,prevent sleep,stay awake,no sleep,workout,display,timer,amphetamine

## What's New (version 1.1)
First release.

## URLs
Support URL: https://nickson.studio/apps/privacy.html
Marketing URL: (leave blank)
Privacy Policy URL: https://nickson.studio/apps/privacy.html

## Category
Primary: Utilities
Secondary: (none)

## Price
Free

## Age rating
All questionnaire answers: None / No → 4+

## App Privacy
Data Not Collected.

## Export compliance
"Does your app use encryption?" → No. (ITSAppUsesNonExemptEncryption is already false in both builds, so this may not even be asked.)

## App Review notes (paste into "Notes" under App Review Information)
Stayawake is a single-purpose utility with no login, no network access and no in-app purchases.

macOS: launches with a control window and a coffee-cup menu bar item. Click the cup (in the window or menu bar) to keep the Mac awake using IOKit power assertions (kIOPMAssertionTypePreventUserIdleDisplaySleep and kIOPMAssertionTypePreventSystemSleep). Click again or choose "Allow sleep" to release. Assertions are released on quit. The app is sandboxed with no entitlements beyond the sandbox itself.

iOS: the main screen keeps the display on via UIApplication.isIdleTimerDisabled while the app is in the foreground, which is the documented mechanism. It shows a stopwatch, clock and battery, has a screen-dim option, and an App Intent so the feature works from Siri and Shortcuts. The idle timer is re-enabled when the user stops, when a chosen duration ends, or when the app leaves the foreground.

Test: open the app, tap the cup, wait longer than the device's auto-lock setting and observe the screen stays on; tap the cup again and observe normal sleep resumes.

Contact: gustav@ormus.solutions

## Screenshots
iPhone 6.9": AppStore/screenshots/iphone-*.png (1320×2868)
Mac: AppStore/screenshots/mac-*.png (2880×1800) — see README in that folder for how they were made.

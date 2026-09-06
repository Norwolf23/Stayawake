# Reply to App Review — macOS 1.1 (Guideline 2.1 Information Needed)

Paste into "Reply to App Review" on the macOS submission and append to the macOS version's Notes field. Attach the QuickTime screen recording.

---

Thank you for the review. Answers to each point:

1. SCREEN RECORDING
Attached: a recording captured on a physical Mac running the latest macOS. It starts from the Finder/Desktop, launches Stayawake from Applications, shows the control window and the coffee-cup menu bar item, clicks the cup to keep the Mac awake, shows the elapsed/remaining time, opens the menu bar item to show the same controls, then clicks "Allow sleep" to release and quits the app. There is no account registration, login, user-generated content, or paid content in the app.

2. PURPOSE AND TARGET AUDIENCE
Stayawake is a single-purpose utility that stops the Mac from going to sleep or dimming the display for a chosen duration (30 minutes, 1 hour, 2 hours, or until turned off). Problem it solves: during presentations, downloads, long builds, or reading, macOS energy settings put the display or system to sleep and the user has to change System Settings and remember to change them back. Stayawake makes this one click from the menu bar and releases the lock automatically. Target audience: general consumers, all ages (rated 4+).

3. SETUP AND ACCESS
No setup, no login, no credentials, no sample files. Launch the app; a control window opens and a coffee cup appears in the menu bar. Click the cup to keep the Mac awake using IOKit power assertions (kIOPMAssertionTypePreventUserIdleDisplaySleep and kIOPMAssertionTypePreventSystemSleep). Click again or choose "Allow sleep" to release. Assertions are always released on quit. To verify: set Display sleep to 1 minute in System Settings > Lock Screen, start Stayawake, wait past a minute and observe the display stays on; stop it and observe normal sleep resumes. Note: closing the lid still sleeps the Mac unless an external display is connected; this is macOS behaviour and the app says so in its UI.

4. EXTERNAL SERVICES
None. The app makes no network requests and uses no third-party SDKs, data providers, authentication, payment processors, analytics, ads, or AI services. All logic runs on-device using Apple frameworks only (SwiftUI, AppKit, IOKit). The app is sandboxed with no entitlements beyond the sandbox itself.

5. REGIONAL DIFFERENCES
None. The app functions identically in all regions. It contains no region-specific content or features.

6. REGULATED INDUSTRY / THIRD-PARTY MATERIAL
Not applicable. The app is not in a regulated industry and contains no third-party protected material. All artwork and code are original.

Contact for any follow-up: gustavnickson@icloud.com

# Reply to App Review (Guideline 2.1 — Information Needed), submission db133c4d

Paste the text below into (a) the "Reply to App Review" message and (b) the Notes field under App Review Information. Attach the screen recording to the reply.

---

Thank you for the review. Answers to each point:

1. SCREEN RECORDING
Attached: a recording captured on a physical iPhone running the latest iOS. It starts from the Home Screen, launches Stayawake, taps the cup to keep the screen on, shows the stopwatch/clock/battery dashboard and the Dim button, waits past the device's Auto-Lock interval to show the screen staying on, then taps the cup again to stop. There is no account registration, login, user-generated content, or paid content in the app.

2. PURPOSE AND TARGET AUDIENCE
Stayawake is a single-purpose utility that keeps the screen from auto-locking for a chosen duration (30 minutes, 1 hour, 2 hours, or until turned off). Problem it solves: people who prop up their phone to follow a workout, a recipe, sheet music, or instructions have to dig into Settings > Display & Brightness to change Auto-Lock, and then remember to change it back. Stayawake makes this one tap and switches itself off automatically so the battery is protected. Target audience: general consumers, all ages (rated 4+). It was originally built for the developer's father to use during workouts.

3. SETUP AND ACCESS
No setup, no login, no credentials, no sample files. Open the app, tap the cup. The screen stays on while the app is in the foreground (via the documented UIApplication.isIdleTimerDisabled). Tap the cup again, or wait for the chosen duration to end, and normal Auto-Lock resumes. Optional: say "Hey Siri, keep my screen on with Stayawake" or use the Shortcuts action with a duration. To verify: set Auto-Lock to 30 seconds, start Stayawake, wait a minute and observe the screen stays on; stop it and observe the screen locks after 30 seconds.

4. EXTERNAL SERVICES
None. The app makes no network requests and uses no third-party SDKs, data providers, authentication, payment processors, analytics, ads, or AI services. All logic runs on-device using Apple frameworks only (SwiftUI, UIKit, AppIntents).

5. REGIONAL DIFFERENCES
None. The app functions identically in all regions. It contains no region-specific content or features.

6. REGULATED INDUSTRY / THIRD-PARTY MATERIAL
Not applicable. The app is not in a regulated industry and contains no third-party protected material. All artwork and code are original.

Contact for any follow-up: gustav@ormus.solutions

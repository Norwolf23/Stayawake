import SwiftUI
import IOKit.pwr_mgt

@main
struct StayAwakeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var keeper = Keeper.shared

    var body: some Scene {
        MenuBarExtra("StayAwake", systemImage: keeper.active ? "cup.and.saucer.fill" : "cup.and.saucer") {
            if keeper.active {
                Text(keeper.status)
                Button("Allow sleep") { keeper.stop() }
            } else {
                Text("Mac can sleep normally")
                Button("Keep awake for 30 minutes") { keeper.start(for: 30 * 60) }
                Button("Keep awake for 1 hour") { keeper.start(for: 60 * 60) }
                Button("Keep awake for 2 hours") { keeper.start(for: 2 * 60 * 60) }
                Button("Keep awake until I turn it off") { keeper.start(for: nil) }
            }
            Divider()
            Button("Quit StayAwake") { NSApp.terminate(nil) }
        }
    }
}

final class Keeper: ObservableObject {
    static let shared = Keeper()
    @Published private(set) var active = false
    @Published private(set) var status = ""
    private var since = Date()
    private var until: Date?
    private var assertions: [IOPMAssertionID] = []
    private var tick: Timer?

    /// duration nil = until turned off
    func start(for duration: TimeInterval?) {
        stop()
        since = Date()
        until = duration.map { since.addingTimeInterval($0) }
        // Display + idle system sleep, and system sleep on AC (lid closed) — like caffeinate -dis
        for type in [kIOPMAssertionTypePreventUserIdleDisplaySleep, kIOPMAssertionTypePreventSystemSleep] {
            var id = IOPMAssertionID(0)
            if IOPMAssertionCreateWithName(type as CFString, IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                           "StayAwake active" as CFString, &id) == kIOReturnSuccess {
                assertions.append(id)
            } else {
                NSLog("StayAwake: failed to create assertion \(type)")
            }
        }
        active = !assertions.isEmpty
        refresh()
        // .common so the status keeps updating while the menu is open
        let t = Timer(timeInterval: 15, repeats: true) { [weak self] _ in self?.refresh() }
        RunLoop.main.add(t, forMode: .common)
        tick = t
    }

    func stop() {
        assertions.forEach { IOPMAssertionRelease($0) }
        assertions = []
        tick?.invalidate(); tick = nil
        until = nil
        active = false
        status = ""
    }

    private func refresh() {
        if let until, Date() >= until { stop(); return }
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.unitsStyle = .abbreviated
        let up = f.string(from: max(60, Date().timeIntervalSince(since))) ?? ""
        if let until, let left = f.string(from: max(60, until.timeIntervalSinceNow)) {
            status = "Awake for \(up) · \(left) left"
        } else {
            status = "Awake for \(up)"
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    // Release assertions on quit so sleep prevention never outlives the app
    func applicationWillTerminate(_ notification: Notification) {
        Keeper.shared.stop()
    }
}

import SwiftUI
import IOKit.pwr_mgt

@main
struct StayAwakeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var keeper = Keeper.shared

    var body: some Scene {
        MenuBarExtra("StayAwake", systemImage: keeper.active ? "cup.and.saucer.fill" : "cup.and.saucer") {
            Button(keeper.active ? "Turn OFF (allow sleep)" : "Keep Awake") {
                keeper.toggle()
            }
            Divider()
            Button("Quit") { NSApp.terminate(nil) }
        }
    }
}

final class Keeper: ObservableObject {
    static let shared = Keeper()
    @Published var active = false
    private var assertions: [IOPMAssertionID] = []

    func toggle() { active ? stop() : start() }

    private func start() {
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
    }

    func stop() {
        assertions.forEach { IOPMAssertionRelease($0) }
        assertions = []
        active = false
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    // Release assertions on quit so sleep prevention never outlives the app
    func applicationWillTerminate(_ notification: Notification) {
        Keeper.shared.stop()
    }
}

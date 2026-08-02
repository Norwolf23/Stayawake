import SwiftUI

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
    private var caffeinate: Process?

    func toggle() { active ? stop() : start() }

    private func start() {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        // -d display, -i idle, -m disk, -s system (AC), -u declare user activity
        p.arguments = ["-dimsu"]
        do {
            try p.run()
            caffeinate = p
            active = true
        } catch {
            NSLog("StayAwake: failed to launch caffeinate: \(error)")
        }
    }

    func stop() {
        caffeinate?.terminate()
        caffeinate = nil
        active = false
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    // Kill the caffeinate child on quit so sleep prevention never outlives the app
    func applicationWillTerminate(_ notification: Notification) {
        Keeper.shared.stop()
    }
}

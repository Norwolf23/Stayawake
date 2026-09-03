import SwiftUI

@main
struct StayawakeApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    @StateObject private var keeper = Keeper.shared

    var body: some Scene {
        #if os(macOS)
        Window("Stayawake", id: "main") {
            ControlView().frame(width: 340, height: 620)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)

        MenuBarExtra("Stayawake", systemImage: keeper.active ? "cup.and.saucer.fill" : "cup.and.saucer") {
            if keeper.active {
                Text(keeper.status)
                Button("Allow sleep") { keeper.stop() }
            } else {
                Text("Mac can sleep normally")
                ForEach(Keeper.durations, id: \.label) { d in
                    Button(d.seconds == nil ? "Keep awake until I turn it off" : "Keep awake for \(d.label)") {
                        keeper.start(for: d.seconds)
                    }
                }
            }
            Divider()
            Button("Quit Stayawake") { NSApp.terminate(nil) }
        }
        #else
        WindowGroup { ControlView() }
        #endif
    }
}

#if os(macOS)
final class AppDelegate: NSObject, NSApplicationDelegate {
    // Release assertions on quit so sleep prevention never outlives the app
    func applicationWillTerminate(_ notification: Notification) {
        Keeper.shared.stop()
    }
}
#endif

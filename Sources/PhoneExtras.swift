#if os(iOS)
import SwiftUI
import AppIntents

/// What the lit-up screen shows during a workout: stopwatch, clock, battery, dim.
struct Dashboard: View {
    @ObservedObject var keeper = Keeper.shared
    @State private var dimmed = false
    @State private var brightnessBefore: CGFloat = 1

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { tl in
            let elapsed = Int(tl.date.timeIntervalSince(keeper.since))
            VStack(spacing: 10) {
                Text(String(format: "%02d:%02d:%02d", elapsed / 3600, elapsed / 60 % 60, elapsed % 60))
                    .font(.system(size: 64, weight: .thin, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                HStack(spacing: 18) {
                    Text(tl.date, style: .time)
                    if UIDevice.current.batteryLevel >= 0 {   // -1 = unknown (simulator)
                        Label("\(Int(UIDevice.current.batteryLevel * 100))%", systemImage: batterySymbol)
                    }
                    if let left = keeper.remaining { Text("\(left) left") }
                }
                .font(.system(.callout, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
                Button(dimmed ? "Brighten" : "Dim screen") { toggleDim() }
                    .buttonStyle(.bordered)
                    .tint(.white)
                    .padding(.top, 6)
            }
        }
        .onAppear { UIDevice.current.isBatteryMonitoringEnabled = true }
        .onDisappear { if dimmed { toggleDim() } }
    }

    private var batterySymbol: String {
        let l = UIDevice.current.batteryLevel
        return l < 0.15 ? "battery.0percent" : l < 0.4 ? "battery.25percent" : l < 0.65 ? "battery.50percent" : l < 0.9 ? "battery.75percent" : "battery.100percent"
    }

    private func toggleDim() {
        if dimmed { UIScreen.main.brightness = brightnessBefore }
        else { brightnessBefore = UIScreen.main.brightness; UIScreen.main.brightness = 0.02 }
        dimmed.toggle()
    }
}

/// "Hey Siri, keep my screen on with Stayawake" — also usable as a Shortcuts action / automation.
struct KeepAwakeIntent: AppIntent {
    static var title: LocalizedStringResource = "Keep my screen on"
    static var description = IntentDescription("Opens Stayawake and keeps the screen on.")
    static var openAppWhenRun = true

    @Parameter(title: "For", default: .untilOff) var duration: AwakeDuration

    @MainActor
    func perform() async throws -> some IntentResult {
        Keeper.shared.start(for: duration.seconds)
        return .result()
    }
}

enum AwakeDuration: String, AppEnum {
    case thirtyMinutes, oneHour, twoHours, untilOff
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Duration")
    static var caseDisplayRepresentations: [AwakeDuration: DisplayRepresentation] = [
        .thirtyMinutes: "30 minutes", .oneHour: "1 hour", .twoHours: "2 hours", .untilOff: "Until I turn it off"
    ]
    var seconds: TimeInterval? {
        switch self {
        case .thirtyMinutes: return 30 * 60
        case .oneHour: return 60 * 60
        case .twoHours: return 2 * 60 * 60
        case .untilOff: return nil
        }
    }
}

struct StayawakeShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: KeepAwakeIntent(),
                    phrases: ["Keep my screen on with \(.applicationName)",
                              "Turn on \(.applicationName)",
                              "Start \(.applicationName)"],
                    shortTitle: "Keep screen on",
                    systemImageName: "cup.and.saucer.fill")
    }
}
#endif

import SwiftUI
#if os(macOS)
import IOKit.pwr_mgt
#endif

/// Keeps the screen/system awake. Mac: IOKit power assertions. iPhone: the idle timer,
/// which only works while the app is on screen — iOS allows nothing more.
final class Keeper: ObservableObject {
    static let shared = Keeper()
    static let durations: [(label: String, seconds: TimeInterval?)] =
        [("30 min", 30 * 60), ("1 h", 60 * 60), ("2 h", 2 * 60 * 60), ("Until off", nil)]

    @Published private(set) var active = false
    @Published private(set) var status = ""
    @Published var duration: TimeInterval? = nil   // chosen in the UI before starting
    private(set) var since = Date()
    private var until: Date?
    private var tick: Timer?
    #if os(macOS)
    private var assertions: [IOPMAssertionID] = []
    #endif

    func toggle() { active ? stop() : start(for: duration) }

    /// "48m", or nil when running until turned off
    var remaining: String? {
        guard let until else { return nil }
        let f = DateComponentsFormatter(); f.allowedUnits = [.hour, .minute]; f.unitsStyle = .abbreviated
        return f.string(from: max(60, until.timeIntervalSinceNow))
    }

    /// duration nil = until turned off
    func start(for duration: TimeInterval?) {
        stop()
        self.duration = duration
        since = Date()
        until = duration.map { since.addingTimeInterval($0) }
        engage()
        refresh()
        // .common so the status keeps updating while a menu is open
        let t = Timer(timeInterval: 15, repeats: true) { [weak self] _ in self?.refresh() }
        RunLoop.main.add(t, forMode: .common)
        tick = t
    }

    func stop() {
        release()
        tick?.invalidate(); tick = nil
        until = nil
        active = false
        status = ""
    }

    private func engage() {
        #if os(macOS)
        // Display + idle system sleep, and system sleep on AC (lid closed) — like caffeinate -dis
        for type in [kIOPMAssertionTypePreventUserIdleDisplaySleep, kIOPMAssertionTypePreventSystemSleep] {
            var id = IOPMAssertionID(0)
            if IOPMAssertionCreateWithName(type as CFString, IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                           "Stayawake active" as CFString, &id) == kIOReturnSuccess {
                assertions.append(id)
            } else {
                NSLog("Stayawake: failed to create assertion \(type)")
            }
        }
        active = !assertions.isEmpty
        #else
        UIApplication.shared.isIdleTimerDisabled = true
        active = true
        #endif
    }

    private func release() {
        #if os(macOS)
        assertions.forEach { IOPMAssertionRelease($0) }
        assertions = []
        #else
        UIApplication.shared.isIdleTimerDisabled = false
        #endif
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

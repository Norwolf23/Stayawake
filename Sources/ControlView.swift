import SwiftUI

/// The one screen: big cup button, status, duration picker. Shared by Mac window and iPhone.
struct ControlView: View {
    @ObservedObject var keeper = Keeper.shared
    private let blue = Color(red: 0.28, green: 0.48, blue: 0.72)

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 0)
            Button(action: keeper.toggle) {
                ZStack {
                    Circle().fill(keeper.active ? blue : Color.secondary.opacity(0.14))
                    Image(systemName: keeper.active ? "cup.and.saucer.fill" : "cup.and.saucer")
                        .font(.system(size: 76, weight: .light))
                        .foregroundStyle(keeper.active ? Color.white : Color.secondary)
                }
                .frame(width: 190, height: 190)
                .shadow(color: keeper.active ? blue.opacity(0.45) : .clear, radius: 26, y: 10)
            }
            .buttonStyle(.plain)
            .animation(.easeInOut(duration: 0.25), value: keeper.active)
            .accessibilityLabel(keeper.active ? "Allow sleep" : "Keep awake")

            Text(keeper.active ? keeper.status : "Tap the cup to keep the screen on")
                .font(.title3.weight(.medium))
                .monospacedDigit()
                .foregroundStyle(keeper.active ? Color.primary : Color.secondary)

            Picker("Duration", selection: $keeper.duration) {
                ForEach(Keeper.durations, id: \.label) { d in
                    Text(d.label).tag(d.seconds)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .disabled(keeper.active)
            .frame(maxWidth: 340)

            #if os(iOS)
            Text("Keep this app open. The screen stays on while you're here.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            #endif
            Spacer(minLength: 0)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

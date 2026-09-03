import SwiftUI

/// The one screen: a big steaming cup on a night-blue gradient, status, duration picker.
/// Shared by the Mac window and iPhone.
struct ControlView: View {
    @ObservedObject var keeper = Keeper.shared

    private var background: LinearGradient {
        LinearGradient(
            colors: keeper.active
                ? [Color(red: 0.16, green: 0.30, blue: 0.52), Color(red: 0.09, green: 0.15, blue: 0.30)]
                : [Color(red: 0.08, green: 0.12, blue: 0.22), Color(red: 0.05, green: 0.07, blue: 0.14)],
            startPoint: .top, endPoint: .bottom)
    }

    var body: some View {
        VStack(spacing: 22) {
            Text("Stayawake")
                .font(.system(size: 28, weight: .light, design: .serif))
                .foregroundStyle(.white.opacity(0.85))
                .padding(.top, 8)
            Spacer(minLength: 0)

            Button(action: keeper.toggle) {
                ZStack {
                    // warm glow behind the cup while awake
                    Circle()
                        .fill(RadialGradient(colors: [Color(red: 0.95, green: 0.72, blue: 0.45).opacity(0.55), .clear],
                                             center: .center, startRadius: 0, endRadius: 150))
                        .frame(width: 300, height: 300)
                        .opacity(keeper.active ? 1 : 0)
                        .blur(radius: 12)
                    VStack(spacing: -18) {
                        SteamView()
                            .frame(width: 140, height: 110)
                            .opacity(keeper.active ? 1 : 0)
                        Image(systemName: keeper.active ? "cup.and.saucer.fill" : "cup.and.saucer")
                            .font(.system(size: 120, weight: .thin))
                            .foregroundStyle(keeper.active ? Color.white : Color.white.opacity(0.35))
                            .shadow(color: .black.opacity(keeper.active ? 0.35 : 0), radius: 18, y: 12)
                    }
                }
                #if os(macOS)
                .frame(height: 250)
                #else
                .frame(height: 280)
                #endif
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .animation(.easeInOut(duration: 0.6), value: keeper.active)
            .accessibilityLabel(keeper.active ? "Allow sleep" : "Keep awake")

            #if os(iOS)
            if keeper.active { Dashboard() } else { statusLine }
            #else
            statusLine
            #endif

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
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            #else
            Text("Closing the lid still puts the Mac to sleep, unless an external display is connected.")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            #endif
            Spacer(minLength: 0)
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(background.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.9), value: keeper.active)
        .preferredColorScheme(.dark)
    }

    private var statusLine: some View {
        Text(keeper.active ? keeper.status : "Tap the cup to keep the screen on")
            .font(.system(.title3, design: .rounded).weight(.medium))
            .monospacedDigit()
            .foregroundStyle(keeper.active ? Color.white : Color.white.opacity(0.6))
    }
}

/// Three wisps of steam that sway and rise. Pure Canvas, no images.
struct SteamView: View {
    var body: some View {
        TimelineView(.animation) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                for i in 0..<3 {
                    let phase = t * 0.9 + Double(i) * 2.1
                    let x0 = size.width * (0.32 + 0.18 * Double(i))
                    var path = Path()
                    let steps = 28
                    for s in 0...steps {
                        let f = Double(s) / Double(steps)              // 0 = cup rim, 1 = top
                        let y = size.height * (1 - f)
                        let sway = sin(f * 5 - phase) * size.width * 0.07 * (0.25 + f)
                        let p = CGPoint(x: x0 + sway, y: y)
                        s == 0 ? path.move(to: p) : path.addLine(to: p)
                    }
                    let pulse = 0.65 + 0.35 * sin(phase * 0.6)
                    let shade = GraphicsContext.Shading.linearGradient(
                        Gradient(colors: [.white.opacity(0.75 * pulse), .white.opacity(0)]),
                        startPoint: CGPoint(x: 0, y: size.height), endPoint: CGPoint(x: 0, y: 0))
                    ctx.stroke(path, with: shade, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                }
            }
            .blur(radius: 2.5)
        }
    }
}

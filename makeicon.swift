// Renders the app icon (white cup.and.saucer.fill on a blue rounded square)
// into AppIcon.iconset/. Run via build.sh.
import AppKit

func render(_ size: Int, _ path: String) {
    let s = CGFloat(size)
    let img = NSImage(size: NSSize(width: s, height: s))
    img.lockFocus()
    let inset = s * 0.09
    let rect = NSRect(x: inset, y: inset, width: s - inset * 2, height: s - inset * 2)
    let bg = NSBezierPath(roundedRect: rect, xRadius: s * 0.2, yRadius: s * 0.2)
    NSColor(calibratedRed: 0.28, green: 0.48, blue: 0.72, alpha: 1).setFill()
    bg.fill()
    let cfg = NSImage.SymbolConfiguration(pointSize: s * 0.45, weight: .regular)
    if let sym = NSImage(systemSymbolName: "cup.and.saucer.fill", accessibilityDescription: nil)?
        .withSymbolConfiguration(cfg) {
        let tinted = NSImage(size: sym.size)
        tinted.lockFocus()
        sym.draw(at: .zero, from: .zero, operation: .sourceOver, fraction: 1)
        NSColor.white.set()
        NSRect(origin: .zero, size: sym.size).fill(using: .sourceAtop)
        tinted.unlockFocus()
        let w = sym.size.width, h = sym.size.height
        let scale = (s * 0.62) / max(w, h)
        let dw = w * scale, dh = h * scale
        tinted.draw(in: NSRect(x: (s - dw) / 2, y: (s - dh) / 2, width: dw, height: dh))
    }
    img.unlockFocus()
    guard let tiff = img.tiffRepresentation, let rep = NSBitmapImageRep(data: tiff),
          let png = rep.representation(using: .png, properties: [:]) else { fatalError() }
    try! png.write(to: URL(fileURLWithPath: path))
}

for sz in [16, 32, 64, 128, 256, 512, 1024] {
    render(sz, "AppIcon.iconset/icon_\(sz).png")
}

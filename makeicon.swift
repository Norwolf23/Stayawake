// Renders the app icon (white cup.and.saucer.fill on a blue rounded square)
// into Assets.xcassets/AppIcon.appiconset/. Run: swift makeicon.swift
import AppKit

func render(_ size: Int, _ path: String) {
    let s = CGFloat(size)
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size, bitsPerSample: 8,
                               samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB,
                               bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
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
    NSGraphicsContext.restoreGraphicsState()
    try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: path))
}

for pt in [16, 32, 128, 256, 512] {
    render(pt, "Assets.xcassets/AppIcon.appiconset/icon_\(pt)x\(pt).png")
    render(pt * 2, "Assets.xcassets/AppIcon.appiconset/icon_\(pt)x\(pt)@2x.png")
}

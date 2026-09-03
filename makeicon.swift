// Renders the app icon (white cup.and.saucer.fill with steam on a blue gradient rounded square)
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
    let tile = NSBezierPath(roundedRect: rect, xRadius: s * 0.2, yRadius: s * 0.2)

    // Tile: same blue, now lit from the top
    NSGradient(colors: [NSColor(calibratedRed: 0.42, green: 0.62, blue: 0.86, alpha: 1),
                        NSColor(calibratedRed: 0.28, green: 0.48, blue: 0.72, alpha: 1),
                        NSColor(calibratedRed: 0.20, green: 0.37, blue: 0.60, alpha: 1)])!
        .draw(in: tile, angle: -90)
    // Soft highlight across the top edge
    NSGraphicsContext.current?.saveGraphicsState()
    tile.addClip()
    NSGradient(starting: NSColor(white: 1, alpha: 0.22), ending: NSColor(white: 1, alpha: 0))!
        .draw(in: NSRect(x: rect.minX, y: rect.maxY - rect.height * 0.35, width: rect.width, height: rect.height * 0.35), angle: -90)
    NSGraphicsContext.current?.restoreGraphicsState()

    // Cup with a soft drop shadow, sitting slightly low to leave room for steam
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
        let scale = (s * 0.58) / max(w, h)
        let dw = w * scale, dh = h * scale
        let cup = NSRect(x: (s - dw) / 2, y: (s - dh) / 2 - s * 0.07, width: dw, height: dh)
        NSGraphicsContext.current?.saveGraphicsState()
        let shadow = NSShadow()
        shadow.shadowColor = NSColor(calibratedRed: 0.05, green: 0.15, blue: 0.35, alpha: 0.45)
        shadow.shadowBlurRadius = s * 0.03
        shadow.shadowOffset = NSSize(width: 0, height: -s * 0.02)
        shadow.set()
        tinted.draw(in: cup)
        NSGraphicsContext.current?.restoreGraphicsState()

        // Three steam wisps rising from the cup
        NSColor(white: 1, alpha: 0.85).setStroke()
        let top = cup.maxY - s * 0.02
        for (i, dx) in [-0.09, 0.0, 0.09].enumerated() {
            let x = s / 2 + s * CGFloat(dx) - s * 0.02
            let rise = s * (i == 1 ? 0.19 : 0.15)
            let p = NSBezierPath()
            p.lineWidth = s * 0.028
            p.lineCapStyle = .round
            p.move(to: NSPoint(x: x, y: top + s * 0.02))
            p.curve(to: NSPoint(x: x, y: top + rise),
                    controlPoint1: NSPoint(x: x - s * 0.05, y: top + rise * 0.35),
                    controlPoint2: NSPoint(x: x + s * 0.05, y: top + rise * 0.7))
            p.stroke()
        }
    }
    NSGraphicsContext.restoreGraphicsState()
    try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: path))
}

for pt in [16, 32, 128, 256, 512] {
    render(pt, "Assets.xcassets/AppIcon.appiconset/icon_\(pt)x\(pt).png")
    render(pt * 2, "Assets.xcassets/AppIcon.appiconset/icon_\(pt)x\(pt)@2x.png")
}

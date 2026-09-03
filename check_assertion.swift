// Sanity check for the power assertions Stayawake creates. Run: swift check_assertion.swift
import Foundation
import IOKit.pwr_mgt

var ids: [IOPMAssertionID] = []
for type in [kIOPMAssertionTypePreventUserIdleDisplaySleep, kIOPMAssertionTypePreventSystemSleep] {
    var id = IOPMAssertionID(0)
    guard IOPMAssertionCreateWithName(type as CFString, IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                      "Stayawake active" as CFString, &id) == kIOReturnSuccess else {
        fatalError("could not create \(type)")
    }
    ids.append(id)
}
sleep(2)
let p = Process(); p.executableURL = URL(fileURLWithPath: "/usr/bin/pmset"); p.arguments = ["-g", "assertions"]
let out = Pipe(); p.standardOutput = out; try! p.run(); p.waitUntilExit()
let text = String(decoding: out.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
ids.forEach { IOPMAssertionRelease($0) }
precondition(text.contains("Stayawake active"), "assertion not visible in pmset -g assertions")
print("OK: both assertions visible in pmset -g assertions")

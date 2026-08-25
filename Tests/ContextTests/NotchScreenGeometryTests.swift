import AppKit
import Testing
@testable import Context

struct NotchScreenGeometryTests {
    @Test func resolvesTheGapBetweenAuxiliaryTopAreas() throws {
        let geometry = try #require(NotchScreenGeometry.resolve(
            screenFrame: NSRect(x: 0, y: 0, width: 1512, height: 982),
            visibleFrame: NSRect(x: 0, y: 0, width: 1512, height: 949),
            safeTopInset: 32,
            auxiliaryTopLeftArea: NSRect(x: 0, y: 950, width: 663.5, height: 32),
            auxiliaryTopRightArea: NSRect(x: 848.5, y: 950, width: 663.5, height: 32)
        ))

        #expect(geometry.notchFrame == NSRect(x: 663.5, y: 950, width: 185, height: 32))
        #expect(geometry.compactFrame == NSRect(
            x: 625.5,
            y: 950,
            width: 261,
            height: 32
        ))
        #expect(geometry.dropFrame == NSRect(
            x: 625.5,
            y: 902,
            width: 261,
            height: 80
        ))
        #expect(geometry.expandedFrame == NSRect(
            x: 476,
            y: 732,
            width: 560,
            height: 250
        ))
    }

    @Test func rejectsScreensWithoutANotchSafeArea() {
        let geometry = NotchScreenGeometry.resolve(
            screenFrame: NSRect(x: 0, y: 0, width: 1920, height: 1080),
            visibleFrame: NSRect(x: 0, y: 0, width: 1920, height: 1055),
            safeTopInset: 0,
            auxiliaryTopLeftArea: nil,
            auxiliaryTopRightArea: nil
        )

        #expect(geometry == nil)
    }

    @Test func rejectsInvalidAuxiliaryAreaOrdering() {
        let geometry = NotchScreenGeometry.resolve(
            screenFrame: NSRect(x: 0, y: 0, width: 1000, height: 700),
            visibleFrame: NSRect(x: 0, y: 0, width: 1000, height: 668),
            safeTopInset: 32,
            auxiliaryTopLeftArea: NSRect(x: 0, y: 668, width: 550, height: 32),
            auxiliaryTopRightArea: NSRect(x: 500, y: 668, width: 500, height: 32)
        )

        #expect(geometry == nil)
    }
}

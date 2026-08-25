import Foundation
import Testing
@testable import Context

struct ShelfPresentationPreferenceTests {
    @Test func defaultsToMenuBarShelf() {
        let (defaults, suiteName) = isolatedDefaults()
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let preference = ShelfPresentationPreference(defaults: defaults)

        #expect(preference.mode == .menuBar)
    }

    @Test func persistsTheSelectedShelfPresentation() {
        let (defaults, suiteName) = isolatedDefaults()
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let preference = ShelfPresentationPreference(defaults: defaults)
        preference.mode = .menuBar

        let restoredPreference = ShelfPresentationPreference(defaults: defaults)
        #expect(restoredPreference.mode == .menuBar)
    }

    @Test func persistsNotchIslandAsAnOptionalPresentation() {
        let (defaults, suiteName) = isolatedDefaults()
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let preference = ShelfPresentationPreference(defaults: defaults)
        preference.mode = .notch

        let restoredPreference = ShelfPresentationPreference(defaults: defaults)
        #expect(restoredPreference.mode == .notch)
    }

    @Test func notchIslandFallsBackToMenuBarWhenUnavailable() {
        #expect(ShelfPresentationMode.notch.resolved(hasNotch: true) == .notch)
        #expect(ShelfPresentationMode.notch.resolved(hasNotch: false) == .menuBar)
        #expect(ShelfPresentationMode.menuBar.resolved(hasNotch: false) == .menuBar)
        #expect(ShelfPresentationMode.floating.resolved(hasNotch: false) == .floating)
    }

    private func isolatedDefaults() -> (UserDefaults, String) {
        let suiteName = "ShelfPresentationPreferenceTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return (defaults, suiteName)
    }
}

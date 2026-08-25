import Combine
import Foundation

enum ShelfPresentationMode: String {
    case floating
    case menuBar
    case notch

    func resolved(hasNotch: Bool) -> ShelfPresentationMode {
        self == .notch && !hasNotch ? .menuBar : self
    }
}

final class ShelfPresentationPreference {
    private static let defaultsKey = "shelfPresentationMode"

    private let defaults: UserDefaults

    var mode: ShelfPresentationMode {
        didSet {
            defaults.set(mode.rawValue, forKey: Self.defaultsKey)
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        mode = defaults.string(forKey: Self.defaultsKey)
            .flatMap(ShelfPresentationMode.init(rawValue:)) ?? .menuBar
    }
}

final class ShelfPresentationState: ObservableObject {
    @Published var isCollapsed = false
}

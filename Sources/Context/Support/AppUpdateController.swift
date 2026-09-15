import AppKit
import Sparkle

@MainActor
final class AppUpdateController: NSObject, @preconcurrency SPUStandardUserDriverDelegate {
    private(set) var controller: SPUStandardUpdaterController!

    override init() {
        super.init()
        controller = SPUStandardUpdaterController(
            startingUpdater: false,
            updaterDelegate: nil,
            userDriverDelegate: self
        )
    }

    func start() {
        controller.startUpdater()
#if DEBUG
        controller.updater.automaticallyChecksForUpdates = false
#endif
    }

    func standardUserDriverWillHandleShowingUpdate(
        _ handleShowingUpdate: Bool,
        forUpdate update: SUAppcastItem,
        state: SPUUserUpdateState
    ) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate()
    }

    func standardUserDriverWillFinishUpdateSession() {
        NSApp.setActivationPolicy(.accessory)
    }
}

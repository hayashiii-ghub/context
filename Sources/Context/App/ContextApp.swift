import AppKit
import OSLog

private let finderImportLogger = Logger(
    subsystem: "work.hayashigoto.Context",
    category: "FinderImport"
)

@main
@MainActor
final class ContextApplication: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private static let bundleIdentifier = "work.hayashigoto.Context"
    private static let shared = ContextApplication()
    private static var singleInstanceGuard: SingleInstanceGuard?
    private static let latestDownloadURL = URL(
        string: "https://github.com/hayashiii-ghub/context/releases/latest/download/context-macos.zip"
    )!
    private static let releasesURL = URL(
        string: "https://github.com/hayashiii-ghub/context/releases/latest"
    )!

    private let store = ShelfStore()
    private let finderSelectionReader = FinderSelectionReader()
    private let presentationPreference = ShelfPresentationPreference()
    private lazy var shelfWindowController = ShelfWindowController(
        store: store,
        onReturnToMenuBar: { [weak self] in
            self?.selectPresentationMode(.menuBar)
        },
        onShowMenu: { [weak self] in
            self?.showStatusMenu()
        }
    )
    private lazy var menuBarShelfController = MenuBarShelfController(
        store: store,
        onKeepOnScreen: { [weak self] in
            self?.selectPresentationMode(.floating)
        },
        onShowMenu: { [weak self] in
            self?.showStatusMenu()
        }
    )
    private lazy var notchShelfController = NotchIslandController(
        store: store,
        onWillShowShelf: { [weak self] in
            self?.hideNonNotchShelves()
        },
        onAddFinderSelection: { [weak self] in
            self?.addFinderSelectionFromNotch()
        },
        onShowMenu: { [weak self] in
            self?.showStatusMenu()
        },
        onUnavailable: { [weak self] in
            self?.fallBackFromUnavailableNotch()
        }
    )
    private var addFinderSelectionHotKey: GlobalHotKey?
    private var toggleShelfHotKey: GlobalHotKey?
    private var statusItem: NSStatusItem?
    private var statusMenu: NSMenu?
    private var copyMenuItem: NSMenuItem?
    private var moveMenuItem: NSMenuItem?
    private var zipMenuItem: NSMenuItem?
    private var clearMenuItem: NSMenuItem?
    private var floatingShelfMenuItem: NSMenuItem?
    private var menuBarShelfMenuItem: NSMenuItem?
    private var notchShelfMenuItem: NSMenuItem?

    static func main() {
        guard let instanceGuard = SingleInstanceGuard(identifier: bundleIdentifier) else {
            activateRunningInstance()
            return
        }
        singleInstanceGuard = instanceGuard

        let app = NSApplication.shared
        app.setActivationPolicy(.accessory)
        app.delegate = shared
        terminateDuplicateInstances()
        app.run()
    }

    private static func activateRunningInstance() {
        let runningInstance = NSWorkspace.shared.runningApplications.first {
            $0.bundleIdentifier == bundleIdentifier
        }
        runningInstance?.activate(options: [])
    }

    private static func terminateDuplicateInstances() {
        let currentProcessIdentifier = ProcessInfo.processInfo.processIdentifier
        for application in NSWorkspace.shared.runningApplications where
            application.processIdentifier != currentProcessIdentifier
            && application.bundleIdentifier == bundleIdentifier {
            application.terminate()
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        store.discardStaleManagedFiles()

        configureStatusItem()
        applySavedPresentationMode()
        toggleShelfHotKey = GlobalHotKey(shortcut: .toggleShelf) { [weak self] in
            self?.togglePreferredShelf()
        }
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(frontmostApplicationDidChange),
            name: NSWorkspace.didActivateApplicationNotification,
            object: nil
        )
        updateFinderSelectionHotKey(
            frontmostBundleIdentifier: NSWorkspace.shared.frontmostApplication?.bundleIdentifier
        )
    }

    func applicationWillTerminate(_ notification: Notification) {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
        notchShelfController.stop()
        addFinderSelectionHotKey = nil
        toggleShelfHotKey = nil
        store.clear()
    }

    func menuWillOpen(_ menu: NSMenu) {
        let hasItems = !store.items.isEmpty
        let canManageItems = hasItems && !store.isExporting
        copyMenuItem?.isEnabled = canManageItems
        moveMenuItem?.isEnabled = canManageItems
        zipMenuItem?.isEnabled = canManageItems
        clearMenuItem?.isEnabled = canManageItems
        floatingShelfMenuItem?.state = presentationPreference.mode == .floating ? .on : .off
        menuBarShelfMenuItem?.state = presentationPreference.mode == .menuBar ? .on : .off
        notchShelfMenuItem?.state = presentationPreference.mode == .notch ? .on : .off
        notchShelfMenuItem?.isEnabled = hasNotchScreen
    }

    private func configureStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = item.button {
            button.image = ShelfIcon.templateImage()
            button.imagePosition = .imageOnly
            button.target = self
            button.action = #selector(statusItemButtonPressed(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        let menu = NSMenu()
        menu.delegate = self

        let addSelectionItem = NSMenuItem(
            title: "Add Finder Selection",
            action: #selector(addFinderSelection),
            keyEquivalent: "\t"
        )
        addSelectionItem.keyEquivalentModifierMask = [.option]
        menu.addItem(addSelectionItem)
        let toggleShelfItem = NSMenuItem(
            title: "Toggle Shelf",
            action: #selector(toggleShelf),
            keyEquivalent: "\t"
        )
        toggleShelfItem.keyEquivalentModifierMask = [.option, .shift]
        menu.addItem(toggleShelfItem)

        let shelfLocationItem = NSMenuItem(title: "Shelf Location", action: nil, keyEquivalent: "")
        let shelfLocationMenu = NSMenu()
        let floatingItem = NSMenuItem(
            title: "On Screen",
            action: #selector(useFloatingShelf),
            keyEquivalent: ""
        )
        let menuBarItem = NSMenuItem(
            title: "Menu Bar",
            action: #selector(useMenuBarShelf),
            keyEquivalent: ""
        )
        let notchItem = NSMenuItem(
            title: "Notch Island",
            action: #selector(useNotchShelf),
            keyEquivalent: ""
        )
        floatingItem.target = self
        menuBarItem.target = self
        notchItem.target = self
        shelfLocationMenu.addItem(menuBarItem)
        shelfLocationMenu.addItem(floatingItem)
        shelfLocationMenu.addItem(notchItem)
        shelfLocationItem.submenu = shelfLocationMenu
        floatingShelfMenuItem = floatingItem
        menuBarShelfMenuItem = menuBarItem
        notchShelfMenuItem = notchItem
        menu.addItem(shelfLocationItem)

        menu.addItem(
            NSMenuItem(
                title: "Add Clipboard Text",
                action: #selector(addClipboardText),
                keyEquivalent: ""
            )
        )
        menu.addItem(.separator())

        let copyItem = NSMenuItem(title: "Copy Items To...", action: #selector(copyItems), keyEquivalent: "")
        let moveItem = NSMenuItem(title: "Move Items To...", action: #selector(moveItems), keyEquivalent: "")
        let zipItem = NSMenuItem(title: "Create ZIP...", action: #selector(createZip), keyEquivalent: "")
        copyMenuItem = copyItem
        moveMenuItem = moveItem
        zipMenuItem = zipItem
        menu.addItem(copyItem)
        menu.addItem(moveItem)
        menu.addItem(zipItem)

        menu.addItem(.separator())

        let clearItem = NSMenuItem(title: "Clear Shelf", action: #selector(clearShelf), keyEquivalent: "")
        clearMenuItem = clearItem
        menu.addItem(clearItem)

        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Download Latest Version...", action: #selector(downloadLatestVersion), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Open Release Page", action: #selector(openReleasePage), keyEquivalent: ""))

        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit Context", action: #selector(quit), keyEquivalent: "q"))

        for item in menu.items where item.action != nil {
            item.target = self
        }

        statusMenu = menu
        statusItem = item
    }

    @objc private func statusItemButtonPressed(_ sender: NSStatusBarButton) {
        if NSApp.currentEvent?.type == .rightMouseUp {
            showStatusMenu()
        } else {
            let event = NSApp.currentEvent
            let eventWindow = event?.window
            let eventLocation = event.flatMap { event in
                eventWindow?.convertPoint(toScreen: event.locationInWindow)
            }
            togglePreferredShelf(
                relativeTo: sender,
                clickLocation: eventLocation ?? NSEvent.mouseLocation,
                clickScreen: eventWindow?.screen
            )
        }
    }

    @objc private func toggleShelf() {
        DispatchQueue.main.async { [weak self] in
            self?.togglePreferredShelf()
        }
    }

    @objc private func addClipboardText() {
        guard store.addClipboardText(NSPasteboard.general.string(forType: .string)) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.showPreferredShelf()
        }
    }

    @objc private func frontmostApplicationDidChange(_ notification: Notification) {
        let application = notification.userInfo?[NSWorkspace.applicationUserInfoKey]
            as? NSRunningApplication
        updateFinderSelectionHotKey(frontmostBundleIdentifier: application?.bundleIdentifier)
    }

    private func updateFinderSelectionHotKey(frontmostBundleIdentifier: String?) {
        let shouldEnable = FinderShortcutAvailability.isEnabled(
            frontmostBundleIdentifier: frontmostBundleIdentifier
        )

        if shouldEnable, addFinderSelectionHotKey == nil {
            addFinderSelectionHotKey = GlobalHotKey(shortcut: .addFinderSelection) { [weak self] in
                self?.addFinderSelection()
            }
            if addFinderSelectionHotKey == nil {
                finderImportLogger.error("Could not register the Option-Tab shortcut")
            } else {
                finderImportLogger.info("Option-Tab enabled for Finder")
            }
        } else if !shouldEnable, addFinderSelectionHotKey != nil {
            addFinderSelectionHotKey = nil
            finderImportLogger.info("Option-Tab disabled outside Finder")
        }
    }

    @objc private func addFinderSelection() {
        let frontmostBundleIdentifier = NSWorkspace.shared.frontmostApplication?.bundleIdentifier
        guard frontmostBundleIdentifier == FinderSelectionReader.finderBundleIdentifier else {
            finderImportLogger.info(
                "Ignored shortcut for frontmost app: \(frontmostBundleIdentifier ?? "unknown", privacy: .public)"
            )
            return
        }

        guard importCurrentFinderSelection() else { return }
        showPreferredShelf()
    }

    private func addFinderSelectionFromNotch() {
        notchShelfController.hideShelf()
        _ = store.addItemsFromOpenPanel()
    }

    @discardableResult
    private func importCurrentFinderSelection() -> Bool {
        do {
            let urls = try finderSelectionReader.selectedFileURLs()
            guard !urls.isEmpty else {
                finderImportLogger.info("Finder selection was empty")
                return false
            }
            store.addFileURLs(urls)
            finderImportLogger.info("Added \(urls.count) Finder selection item(s)")
            return true
        } catch {
            finderImportLogger.error("Finder selection failed: \(error.localizedDescription, privacy: .public)")
            let alert = NSAlert(error: error)
            alert.messageText = "Could Not Read Finder Selection"
            alert.runModal()
            return false
        }
    }

    @objc private func copyItems() {
        store.copyItemsToChosenFolder()
    }

    @objc private func moveItems() {
        store.moveItemsToChosenFolder()
    }

    @objc private func createZip() {
        store.createZipArchive()
    }

    @objc private func clearShelf() {
        store.clear()
    }

    @objc private func useFloatingShelf() {
        selectPresentationMode(.floating)
    }

    @objc private func useMenuBarShelf() {
        selectPresentationMode(.menuBar)
    }

    @objc private func useNotchShelf() {
        selectPresentationMode(.notch)
    }

    @objc private func downloadLatestVersion() {
        NSWorkspace.shared.open(Self.latestDownloadURL)
    }

    @objc private func openReleasePage() {
        NSWorkspace.shared.open(Self.releasesURL)
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }

    private func showPreferredShelf() {
        switch presentationPreference.mode {
        case .floating:
            notchShelfController.stop()
            menuBarShelfController.hideShelf()
            shelfWindowController.showShelf()
        case .menuBar:
            notchShelfController.stop()
            shelfWindowController.hideShelf()
            guard let button = statusItem?.button else { return }
            menuBarShelfController.showShelf(relativeTo: button)
        case .notch:
            shelfWindowController.hideShelf()
            menuBarShelfController.hideShelf()
            guard notchShelfController.start() else {
                fallBackFromUnavailableNotch()
                return
            }
            notchShelfController.showShelf()
        }
    }

    private func togglePreferredShelf(
        relativeTo clickedButton: NSStatusBarButton? = nil,
        clickLocation: NSPoint? = nil,
        clickScreen: NSScreen? = nil
    ) {
        switch presentationPreference.mode {
        case .floating:
            notchShelfController.stop()
            menuBarShelfController.hideShelf()
            shelfWindowController.toggleShelf()
        case .menuBar:
            notchShelfController.stop()
            shelfWindowController.hideShelf()
            guard let button = clickedButton ?? statusItem?.button else { return }
            menuBarShelfController.toggleShelf(
                relativeTo: button,
                clickLocation: clickLocation,
                clickScreen: clickScreen
            )
        case .notch:
            shelfWindowController.hideShelf()
            menuBarShelfController.hideShelf()
            guard notchShelfController.start() else {
                fallBackFromUnavailableNotch()
                return
            }
            notchShelfController.toggleShelf()
        }
    }

    private func selectPresentationMode(_ mode: ShelfPresentationMode) {
        presentationPreference.mode = mode.resolved(hasNotch: hasNotchScreen)
        shelfWindowController.hideShelf()
        menuBarShelfController.hideShelf()
        notchShelfController.stop()

        DispatchQueue.main.async { [weak self] in
            self?.showPreferredShelf()
        }
    }

    private func showStatusMenu() {
        guard let statusItem, let statusMenu else { return }

        notchShelfController.hideShelf()
        menuBarShelfController.hideShelf()
        statusItem.menu = statusMenu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    private func hideNonNotchShelves() {
        shelfWindowController.hideShelf()
        menuBarShelfController.hideShelf()
    }

    private var hasNotchScreen: Bool {
        NSScreen.screens.contains { $0.contextNotchGeometry != nil }
    }

    private func applySavedPresentationMode() {
        let resolvedMode = presentationPreference.mode.resolved(hasNotch: hasNotchScreen)
        presentationPreference.mode = resolvedMode
        if resolvedMode == .notch, !notchShelfController.start() {
            fallBackFromUnavailableNotch()
        } else if resolvedMode != .notch {
            notchShelfController.stop()
        }
    }

    private func fallBackFromUnavailableNotch() {
        guard presentationPreference.mode == .notch else { return }
        presentationPreference.mode = .menuBar
        notchShelfController.stop()
        shelfWindowController.hideShelf()
        menuBarShelfController.hideShelf()
    }
}

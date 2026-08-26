import CoreGraphics
import Foundation

func post(_ type: CGEventType, at point: CGPoint, flags: CGEventFlags = []) {
    let event = CGEvent(
        mouseEventSource: nil,
        mouseType: type,
        mouseCursorPosition: point,
        mouseButton: .left
    )!
    event.flags = flags
    event.post(tap: .cghidEventTap)
}

func click(_ point: CGPoint, flags: CGEventFlags = []) {
    post(.mouseMoved, at: point, flags: flags)
    usleep(120_000)
    post(.leftMouseDown, at: point, flags: flags)
    usleep(100_000)
    post(.leftMouseUp, at: point, flags: flags)
}

func drag(_ start: CGPoint, _ end: CGPoint) {
    post(.mouseMoved, at: start)
    usleep(180_000)
    post(.leftMouseDown, at: start)
    usleep(220_000)
    for step in 1...36 {
        let progress = Double(step) / 36.0
        let eased = progress * progress * (3 - 2 * progress)
        let point = CGPoint(
            x: start.x + (end.x - start.x) * eased,
            y: start.y + (end.y - start.y) * eased
        )
        post(.leftMouseDragged, at: point)
        usleep(28_000)
    }
    usleep(350_000)
    post(.leftMouseUp, at: end)
}

func dragWithHold(_ start: CGPoint, _ end: CGPoint, holdMicroseconds: useconds_t) {
    post(.mouseMoved, at: start)
    usleep(180_000)
    post(.leftMouseDown, at: start)
    usleep(220_000)
    for step in 1...42 {
        let progress = Double(step) / 42.0
        let eased = progress * progress * (3 - 2 * progress)
        let point = CGPoint(
            x: start.x + (end.x - start.x) * eased,
            y: start.y + (end.y - start.y) * eased
        )
        post(.leftMouseDragged, at: point)
        usleep(30_000)
    }
    usleep(holdMicroseconds)
    post(.leftMouseUp, at: end)
}

func dragToNotchIsland(_ start: CGPoint) {
    // Enter the Island's expanded drop frame directly. Touching the physical
    // top edge first also invokes macOS Mission Control while dragging.
    let dropZone = CGPoint(x: 756, y: 68)
    post(.mouseMoved, at: start)
    usleep(180_000)
    post(.leftMouseDown, at: start)
    usleep(220_000)
    for step in 1...42 {
        let progress = Double(step) / 42.0
        let eased = progress * progress * (3 - 2 * progress)
        let point = CGPoint(
            x: start.x + (dropZone.x - start.x) * eased,
            y: start.y + (dropZone.y - start.y) * eased
        )
        post(.leftMouseDragged, at: point)
        usleep(30_000)
    }
    usleep(180_000)
    post(.leftMouseUp, at: dropZone)
}

func optionTab() {
    let down = CGEvent(keyboardEventSource: nil, virtualKey: 48, keyDown: true)!
    down.flags = .maskAlternate
    down.post(tap: .cghidEventTap)
    usleep(120_000)

    let up = CGEvent(keyboardEventSource: nil, virtualKey: 48, keyDown: false)!
    up.flags = .maskAlternate
    up.post(tap: .cghidEventTap)
}

func pressKey(_ virtualKey: CGKeyCode, flags: CGEventFlags = []) {
    let down = CGEvent(keyboardEventSource: nil, virtualKey: virtualKey, keyDown: true)!
    down.flags = flags
    down.post(tap: .cghidEventTap)
    usleep(120_000)

    let up = CGEvent(keyboardEventSource: nil, virtualKey: virtualKey, keyDown: false)!
    up.flags = flags
    up.post(tap: .cghidEventTap)
}

func holdPinnedSequence() {
    let neutral = CGPoint(x: 756, y: 850)
    post(.mouseMoved, at: neutral)
    usleep(800_000)
    drag(CGPoint(x: 1060, y: 105), CGPoint(x: 760, y: 400))
    usleep(1_000_000)
    click(CGPoint(x: 862, y: 400))
    usleep(1_500_000)
    post(.mouseMoved, at: neutral)
    usleep(700_000)
}

func placeSequence() {
    let neutral = CGPoint(x: 590, y: 650)
    post(.mouseMoved, at: neutral)
    usleep(800_000)
    dragToNotchIsland(CGPoint(x: 657, y: 338))
    usleep(2_300_000)
    click(CGPoint(x: 645, y: 16))
    usleep(1_800_000)
    post(.mouseMoved, at: neutral)
    usleep(700_000)
}

func recordScreen(path: String, duration: Int, action: () -> Void) {
    let recorder = Process()
    recorder.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
    recorder.arguments = ["-v", "-V\(duration)", "-D1", "-C", "-k", path]
    try! recorder.run()
    usleep(1_200_000)
    action()
    recorder.waitUntilExit()
}

let args = CommandLine.arguments
guard args.count >= 2 else { exit(2) }

if args[1] == "option-tab" {
    optionTab()
} else if args[1] == "space-right", args.count >= 3 {
    let count = Int(args[2])!
    for _ in 0..<count {
        pressKey(124, flags: .maskControl)
        usleep(900_000)
    }
} else if args[1] == "space-left", args.count >= 3 {
    let count = Int(args[2])!
    for _ in 0..<count {
        pressKey(123, flags: .maskControl)
        usleep(900_000)
    }
} else if args[1] == "mission-control" {
    pressKey(126, flags: .maskControl)
    usleep(1_200_000)
} else if args[1] == "capture-sequence", args.count >= 8 {
    let first = CGPoint(x: Double(args[2])!, y: Double(args[3])!)
    let second = CGPoint(x: Double(args[4])!, y: Double(args[5])!)
    let neutral = CGPoint(x: Double(args[6])!, y: Double(args[7])!)

    post(.mouseMoved, at: neutral)
    usleep(800_000)
    click(first)
    usleep(350_000)
    click(second, flags: .maskCommand)
    usleep(750_000)
    optionTab()
    usleep(1_400_000)
    post(.mouseMoved, at: neutral)
    usleep(700_000)
} else if args[1] == "hold-sequence" {
    let neutral = CGPoint(x: 756, y: 850)
    post(.mouseMoved, at: neutral)
    usleep(800_000)
    click(CGPoint(x: 1103, y: 58))
    usleep(1_100_000)
    drag(CGPoint(x: 1165, y: 150), CGPoint(x: 850, y: 420))
    usleep(1_000_000)
    click(CGPoint(x: 906, y: 421))
    usleep(1_500_000)
    post(.mouseMoved, at: neutral)
    usleep(700_000)
} else if args[1] == "hold-pinned-sequence" {
    holdPinnedSequence()
} else if args[1] == "record-hold", args.count >= 3 {
    recordScreen(path: args[2], duration: 11) {
        holdPinnedSequence()
    }
} else if args[1] == "place-sequence" {
    placeSequence()
} else if args[1] == "record-place", args.count >= 3 {
    recordScreen(path: args[2], duration: 12) {
        placeSequence()
    }
} else if args[1] == "click", args.count >= 4 {
    let point = CGPoint(x: Double(args[2])!, y: Double(args[3])!)
    click(point)
} else if args[1] == "drag", args.count >= 6 {
    let start = CGPoint(x: Double(args[2])!, y: Double(args[3])!)
    let end = CGPoint(x: Double(args[4])!, y: Double(args[5])!)
    drag(start, end)
}

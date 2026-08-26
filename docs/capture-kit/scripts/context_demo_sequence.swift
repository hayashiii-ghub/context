import CoreGraphics
import Foundation

func mouse(_ type: CGEventType, _ point: CGPoint) {
    let event = CGEvent(
        mouseEventSource: nil,
        mouseType: type,
        mouseCursorPosition: point,
        mouseButton: .left
    )!
    event.post(tap: .cghidEventTap)
}

func move(to point: CGPoint) {
    mouse(.mouseMoved, point)
    usleep(180_000)
}

func click(_ point: CGPoint) {
    move(to: point)
    mouse(.leftMouseDown, point)
    usleep(110_000)
    mouse(.leftMouseUp, point)
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

func drag(from start: CGPoint, to end: CGPoint) {
    move(to: start)
    mouse(.leftMouseDown, start)
    usleep(220_000)
    for step in 1...48 {
        let progress = Double(step) / 48.0
        let eased = progress * progress * (3.0 - 2.0 * progress)
        let point = CGPoint(
            x: start.x + (end.x - start.x) * eased,
            y: start.y + (end.y - start.y) * eased
        )
        mouse(.leftMouseDragged, point)
        usleep(28_000)
    }
    usleep(260_000)
    mouse(.leftMouseUp, end)
}

let productBrief = CGPoint(x: 130, y: 360)
let shelfItem = CGPoint(x: 1038, y: 105)
let dropTarget = CGPoint(x: 1040, y: 535)
let neutral = CGPoint(x: 740, y: 820)

move(to: neutral)
usleep(1_200_000)
click(productBrief)
usleep(700_000)
optionTab()
usleep(1_250_000)
drag(from: shelfItem, to: dropTarget)
usleep(450_000)
move(to: neutral)
usleep(1_600_000)

import AppKit
import SwiftUI

struct WindowDragHandle: NSViewRepresentable {
    func makeNSView(context: NSViewRepresentableContext<Self>) -> NSView {
        DragHandleView()
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<Self>) {}
}

private final class DragHandleView: NSView {
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }

    override func mouseDown(with event: NSEvent) {
        window?.performDrag(with: event)
    }
}

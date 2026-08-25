import AppKit
import SwiftUI

enum NotchIslandPhase: Equatable {
    case compact
    case targeted
    case expanded
    case accepted
}

final class NotchIslandPresentationState: ObservableObject {
    @Published var phase: NotchIslandPhase = .compact

    func showAcceptedDrop() {
        phase = .accepted
    }

    func finishAcceptedDrop() {
        phase = .compact
    }
}

struct NotchIslandView: View {
    @ObservedObject var store: ShelfStore
    @ObservedObject var presentation: NotchIslandPresentationState
    let topInset: CGFloat
    let notchWidth: CGFloat
    let sideTabWidth: CGFloat
    let onToggleExpanded: () -> Void
    let onDismiss: () -> Void
    let onAddFinderSelection: () -> Void
    let onShowMenu: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            islandShell

            ZStack(alignment: .top) {
                compactView
                    .opacity(isCompact ? 1 : 0)
                    .allowsHitTesting(isCompact)
                    .accessibilityHidden(!isCompact)

                dropView
                    .opacity(isDropState ? 1 : 0)
                    .allowsHitTesting(isDropState)
                    .accessibilityHidden(!isDropState)

                expandedView
                    .opacity(isExpanded ? 1 : 0)
                    .allowsHitTesting(isExpanded)
                    .accessibilityHidden(!isExpanded)
                    .animation(
                        isExpanded
                            ? .easeOut(duration: 0.12).delay(0.14)
                            : .linear(duration: 0.03),
                        value: isExpanded
                    )
            }
            .frame(
                width: NotchScreenGeometry.expandedSize.width,
                height: NotchScreenGeometry.expandedSize.height,
                alignment: .top
            )
            .mask(alignment: .top) {
                islandMask
            }
        }
        .frame(
            width: NotchScreenGeometry.expandedSize.width,
            height: NotchScreenGeometry.expandedSize.height,
            alignment: .top
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Context Island")
    }

    private var islandShell: some View {
        NotchIslandShape(cornerRadius: shellCornerRadius)
            .fill(Color.black)
            .overlay {
                NotchIslandShape(cornerRadius: shellCornerRadius)
                    .strokeBorder(.white.opacity(isExpanded ? 0.12 : 0), lineWidth: 0.5)
            }
            .frame(width: visibleSize.width, height: visibleSize.height)
            .animation(shellAnimation, value: presentation.phase)
    }

    private var islandMask: some View {
        NotchIslandShape(cornerRadius: shellCornerRadius)
            .frame(width: visibleSize.width, height: visibleSize.height)
            .animation(shellAnimation, value: presentation.phase)
    }

    private var compactView: some View {
        ZStack {
            Color.clear
                .overlay(alignment: .leading) {
                    Image(nsImage: ShelfIcon.vectorTemplateImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.white.opacity(0.88))
                        .padding(.leading, 9)
                }
                .overlay(alignment: .trailing) {
                    Text(itemCountLabel)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(width: 20)
                        .padding(.trailing, 9)
                        .accessibilityLabel("\(store.items.count) items in Context")
                }
        }
        .frame(width: compactSize.width, height: compactSize.height)
        .contentShape(NotchIslandShape(cornerRadius: 12))
        .onTapGesture(perform: onToggleExpanded)
        .help("Open Context")
    }

    private var dropView: some View {
        ZStack(alignment: .bottom) {
            Color.clear

            Group {
                switch presentation.phase {
                case .accepted:
                    Label("Added to Context", systemImage: "checkmark")
                default:
                    Label("Drop to Context", systemImage: "arrow.down")
                }
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.white)
            .frame(height: NotchScreenGeometry.dropExtraHeight)
        }
        .frame(width: dropSize.width, height: dropSize.height)
    }

    private var expandedView: some View {
        VStack(spacing: 0) {
            expandedHeader

            Rectangle()
                .fill(.white.opacity(0.08))
                .frame(height: 1)

            recentItems
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Rectangle()
                .fill(.white.opacity(0.08))
                .frame(height: 1)

            expandedFooter
        }
        .frame(
            width: NotchScreenGeometry.expandedSize.width,
            height: NotchScreenGeometry.expandedSize.height
        )
    }

    private var expandedHeader: some View {
        HStack(spacing: 10) {
            Image(nsImage: ShelfIcon.vectorTemplateImage())
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)

            Text("Context")
                .font(.system(size: 13, weight: .semibold))

            Spacer(minLength: notchWidth)

            Text(itemCountLabel)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white.opacity(0.8))
                .frame(width: 20)

            islandIconButton("ellipsis", help: "Context Menu", action: onShowMenu)
            islandIconButton("xmark", help: "Close", action: onDismiss)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 18)
        .padding(.top, max(0, topInset - 32))
        .frame(height: topInset + 12)
    }

    private var recentItems: some View {
        VStack(alignment: .leading, spacing: 10) {
            if store.items.count > recentItemsList.count {
                HStack {
                    Spacer()

                    Text("Latest \(recentItemsList.count) of \(store.items.count)")
                        .font(.system(size: 10))
                        .foregroundStyle(.white.opacity(0.36))
                }
            }

            if recentItemsList.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "arrow.down.to.line")
                        .font(.system(size: 18, weight: .light))
                    Text("Drop files, links, images, or text here.")
                        .font(.system(size: 11))
                }
                .foregroundStyle(.white.opacity(0.42))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                HStack(spacing: 10) {
                    ForEach(recentItemsList) { item in
                        NotchRecentItemCard(item: item, store: store)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
    }

    private var expandedFooter: some View {
        HStack(spacing: 8) {
            footerButton("folder.badge.plus", label: "Add from Finder", action: onAddFinderSelection)

            footerButton("clipboard", label: "Add Clipboard") {
                _ = store.addClipboardText(NSPasteboard.general.string(forType: .string))
            }

            Spacer()

            footerButton("square.on.square", label: "Export") {
                store.copyItemsToChosenFolder()
            }
            .disabled(store.items.isEmpty || store.isExporting)
        }
        .padding(.horizontal, 14)
        .frame(height: 46)
    }

    private var recentItemsList: [ShelfItem] {
        Array(store.items.suffix(5).reversed())
    }

    private var visibleSize: NSSize {
        switch presentation.phase {
        case .compact:
            NSSize(
                width: notchWidth + sideTabWidth * 2,
                height: topInset
            )
        case .targeted, .accepted:
            NSSize(
                width: max(
                    NotchScreenGeometry.dropMinimumWidth,
                    notchWidth + sideTabWidth * 2
                ),
                height: topInset + NotchScreenGeometry.dropExtraHeight
            )
        case .expanded:
            NotchScreenGeometry.expandedSize
        }
    }

    private var compactSize: NSSize {
        NSSize(
            width: notchWidth + sideTabWidth * 2,
            height: topInset
        )
    }

    private var dropSize: NSSize {
        NSSize(
            width: max(
                NotchScreenGeometry.dropMinimumWidth,
                notchWidth + sideTabWidth * 2
            ),
            height: topInset + NotchScreenGeometry.dropExtraHeight
        )
    }

    private var isCompact: Bool {
        presentation.phase == .compact
    }

    private var isDropState: Bool {
        presentation.phase == .targeted || presentation.phase == .accepted
    }

    private var isExpanded: Bool {
        presentation.phase == .expanded
    }

    private var shellCornerRadius: CGFloat {
        switch presentation.phase {
        case .compact: 12
        case .targeted, .accepted: 20
        case .expanded: 22
        }
    }

    private var shellAnimation: Animation {
        .spring(response: 0.34, dampingFraction: 0.86)
    }

    private var itemCountLabel: String {
        store.items.count > 99 ? "99+" : "\(store.items.count)"
    }

    private func islandIconButton(
        _ systemImage: String,
        help: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 11, weight: .medium))
                .frame(width: 24, height: 24)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .help(help)
    }

    private func footerButton(
        _ systemImage: String,
        label: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Label(label, systemImage: systemImage)
                .font(.system(size: 10, weight: .medium))
                .padding(.horizontal, 10)
                .frame(height: 26)
                .background(.white.opacity(0.07), in: Capsule())
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white.opacity(0.76))
    }
}

private struct NotchRecentItemCard: View {
    let item: ShelfItem
    @ObservedObject var store: ShelfStore
    @State private var isHovering = false

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(alignment: .top) {
                Image(systemName: item.kind.systemImage)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.white.opacity(0.68))

                Spacer()

                if isHovering {
                    Button(role: .destructive) {
                        store.remove(item)
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 9, weight: .semibold))
                            .frame(width: 18, height: 18)
                            .background(.black.opacity(0.35), in: Circle())
                    }
                    .buttonStyle(.plain)
                    .help("Remove")
                }
            }

            Spacer(minLength: 0)

            Text(item.displayTitle)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.88))
                .lineLimit(2)
                .truncationMode(.middle)

            Text(itemKindLabel)
                .font(.system(size: 9, weight: .regular, design: .monospaced))
                .foregroundStyle(.white.opacity(0.34))
                .lineLimit(1)
        }
        .padding(10)
        .frame(width: 94, height: 98, alignment: .leading)
        .background(
            .white.opacity(isHovering ? 0.11 : 0.065),
            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(.white.opacity(isHovering ? 0.14 : 0.07), lineWidth: 0.5)
        }
        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .onTapGesture { store.open(item) }
        .onDrag { item.dragProvider() }
        .onHover { isHovering = $0 }
        .contextMenu {
            Button("Open") { store.open(item) }
            Button("Copy") { store.copyToPasteboard(item) }
            if item.secondaryAction == .reveal {
                Button("Reveal") { store.reveal(item) }
            }
            Divider()
            Button("Remove", role: .destructive) { store.remove(item) }
        }
        .help("Open \(item.displayTitle)")
    }

    private var itemKindLabel: String {
        switch item.kind {
        case .file: "FILE"
        case .folder: "FOLDER"
        case .link: "LINK"
        case .text: "TEXT"
        case .image: "IMAGE"
        }
    }
}

private struct NotchIslandShape: InsettableShape {
    var cornerRadius: CGFloat
    var inset: CGFloat = 0

    var animatableData: CGFloat {
        get { cornerRadius }
        set { cornerRadius = newValue }
    }

    func path(in rect: CGRect) -> Path {
        UnevenRoundedRectangle(
            cornerRadii: .init(
                topLeading: 0,
                bottomLeading: cornerRadius,
                bottomTrailing: cornerRadius,
                topTrailing: 0
            ),
            style: .continuous
        )
        .inset(by: inset)
        .path(in: rect)
    }

    func inset(by amount: CGFloat) -> NotchIslandShape {
        var shape = self
        shape.inset += amount
        return shape
    }
}

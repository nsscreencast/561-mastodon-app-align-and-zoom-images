import AppKit
import SwiftUI
import Manfred

final class GalleryWindowManager {
    static let shared = GalleryWindowManager()

    private var windowController: GalleryWindowController?

    func show(media: [MediaAttachment], selectedIndex: Int, sourceRect: NSRect) {
        windowController?.close()

        windowController = GalleryWindowController(
            media: media,
            selectedIndex: selectedIndex,
            sourceRect: sourceRect
        )
        windowController?.showWindow(self)
    }
}

private final class GalleryWindowController: NSWindowController {
    convenience init(media: [MediaAttachment], selectedIndex: Int, sourceRect: NSRect) {
        let panel = NSPanel(
            contentRect: sourceRect,
            styleMask: [.hudWindow, .utilityWindow, .closable, .resizable, .titled],
            backing: .buffered,
            defer: false
        )
        panel.contentView = NSHostingView(
            rootView:
                GalleryRoot(media: media, selectedIndex: selectedIndex)
                .frame(minWidth: sourceRect.width, maxWidth: .infinity, minHeight: sourceRect.height, maxHeight: .infinity)
        )
        self.init(window: panel)
    }

    override func showWindow(_ sender: Any?) {
        guard let window else { return }

        window.makeKeyAndOrderFront(self)

        let largerFrame = window.frame.insetBy(dx: -window.frame.width, dy: -window.frame.height)
        window.setFrame(largerFrame, display: true, animate: true)
    }
}

private struct GalleryRoot: View {
    let media: [MediaAttachment]
    let selectedIndex: Int

    var body: some View {
        imageItem(imageURL: media[selectedIndex].url)
    }

    private func imageItem(imageURL: URL) -> some View {
        RemoteImageView(url: imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
                .controlSize(.small)
        }
        .frame(minWidth: 200, minHeight: 200)
    }
}

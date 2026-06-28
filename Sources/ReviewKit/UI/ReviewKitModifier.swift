#if canImport(SwiftUI)
import SwiftUI

// MARK: - ReviewKitModifier

/// A `ViewModifier` that attaches the ReviewKit prompt overlay to any SwiftUI view.
///
/// Apply it via the ``SwiftUI/View/reviewKit(manager:)`` convenience extension.
public struct ReviewKitModifier: ViewModifier {

    @ObservedObject private var manager: ReviewManager

    /// Creates a modifier backed by the given manager.
    public init(manager: ReviewManager) {
        self.manager = manager
    }

    public func body(content: Content) -> some View {
        ZStack {
            content

            if manager.isShowingPrompt {
                ReviewKitOverlay()
                    .environmentObject(manager)
                    .zIndex(1000)
            }
        }
        .animation(
            manager.config.enableAnimations
                ? .spring(response: 0.45, dampingFraction: 0.8)
                : .none,
            value: manager.isShowingPrompt
        )
    }
}
#endif

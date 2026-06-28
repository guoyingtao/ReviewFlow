#if canImport(SwiftUI)
import SwiftUI

// MARK: - View + ReviewKit

public extension View {

    /// Attaches the ReviewKit prompt overlay to this view using a specific manager.
    ///
    /// Place this modifier on the root view of your app so the overlay can
    /// cover the entire screen.
    ///
    /// ```swift
    /// ContentView()
    ///     .reviewKit(manager: reviewManager)
    /// ```
    ///
    /// - Parameter manager: The ``ReviewManager`` instance driving the flow.
    func reviewKit(manager: ReviewManager) -> some View {
        modifier(ReviewKitModifier(manager: manager))
    }

    /// Attaches the ReviewKit prompt overlay using the ``ReviewManager/shared``
    /// singleton.
    ///
    /// ```swift
    /// ContentView()
    ///     .reviewKit()
    /// ```
    func reviewKit() -> some View {
        modifier(ReviewKitModifier(manager: .shared))
    }
}
#endif

#if canImport(SwiftUI)
import SwiftUI

// MARK: - View + ReviewFlow

public extension View {

    /// Attaches the ReviewFlow prompt overlay to this view using a specific manager.
    ///
    /// Place this modifier on the root view of your app so the overlay can
    /// cover the entire screen.
    ///
    /// ```swift
    /// ContentView()
    ///     .reviewFlow(manager: reviewManager)
    /// ```
    ///
    /// - Parameter manager: The ``ReviewManager`` instance driving the flow.
    @MainActor
    func reviewFlow(manager: ReviewManager) -> some View {
        modifier(ReviewFlowModifier(manager: manager))
    }

    /// Attaches the ReviewFlow prompt overlay using the ``ReviewManager/shared``
    /// singleton.
    ///
    /// ```swift
    /// ContentView()
    ///     .reviewFlow()
    /// ```
    @MainActor
    func reviewFlow() -> some View {
        modifier(ReviewFlowModifier(manager: .shared))
    }
}
#endif

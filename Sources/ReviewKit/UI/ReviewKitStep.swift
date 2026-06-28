#if canImport(SwiftUI)
import Foundation

// MARK: - ReviewKitStep

/// Tracks which card is currently visible in the review flow.
enum ReviewKitStep {
    /// The initial sentiment question.
    case sentiment
    /// The "Rate App or Send Feedback?" choice shown to neutral users.
    case rateChoice
    /// The feedback options shown to unhappy users.
    case feedback
}
#endif

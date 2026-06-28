#if canImport(SwiftUI)
import Foundation

// MARK: - ReviewFlowStep

/// Tracks which card is currently visible in the review flow.
enum ReviewFlowStep {
    /// The initial sentiment question.
    case sentiment
    /// The "Rate App or Send Feedback?" choice shown to neutral users.
    case rateChoice
    /// The feedback options shown to unhappy users.
    case feedback
}
#endif

import Foundation

// MARK: - ReviewManagerDelegate

/// Callback interface for key events in the ReviewKit lifecycle.
///
/// Implement this protocol to react to review prompt events — e.g. to log to
/// your own analytics system, show a custom thank-you screen, or take action
/// after the user submits feedback.
///
/// All delegate methods have empty default implementations so you only need to
/// implement the callbacks you care about.
public protocol ReviewManagerDelegate: AnyObject {

    /// Called after the review prompt becomes visible.
    func reviewManagerDidShowPrompt(_ manager: ReviewManager)

    /// Called after the prompt is dismissed (regardless of the user's choice).
    func reviewManagerDidDismissPrompt(_ manager: ReviewManager)

    /// Called each time ``ReviewManager/recordLaunch()`` is invoked.
    ///
    /// - Parameter count: The cumulative launch count after recording.
    func reviewManager(_ manager: ReviewManager, didRecordLaunch count: Int)

    /// Called each time ``ReviewManager/recordEvent(_:)`` is invoked.
    ///
    /// - Parameter name: The event name that was recorded.
    func reviewManager(_ manager: ReviewManager, didRecordEvent name: String)

    /// Called when the user selects a sentiment option in the prompt.
    func reviewManager(_ manager: ReviewManager, didReceiveSentiment sentiment: UserSentiment)
}

// MARK: Default implementations

public extension ReviewManagerDelegate {
    func reviewManagerDidShowPrompt(_ manager: ReviewManager) {}
    func reviewManagerDidDismissPrompt(_ manager: ReviewManager) {}
    func reviewManager(_ manager: ReviewManager, didRecordLaunch count: Int) {}
    func reviewManager(_ manager: ReviewManager, didRecordEvent name: String) {}
    func reviewManager(_ manager: ReviewManager, didReceiveSentiment sentiment: UserSentiment) {}
}

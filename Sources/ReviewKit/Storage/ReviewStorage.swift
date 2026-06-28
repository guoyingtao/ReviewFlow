import Foundation

// MARK: - ReviewStorage

/// A type that persists ReviewKit's state between app sessions.
///
/// Conform to this protocol to replace the built-in ``UserDefaultsReviewStorage``
/// with a custom backend (e.g. Keychain, CloudKit, Core Data).
///
/// All properties must be thread-safe; ReviewKit may access them from any queue.
public protocol ReviewStorage: AnyObject {

    /// Total number of times the app has been launched.
    var launchCount: Int { get set }

    /// The date of the first recorded launch.
    var firstLaunchDate: Date? { get set }

    /// The date when the review prompt was most recently shown.
    var lastPromptDate: Date? { get set }

    /// The app version string for which a prompt was last shown.
    var lastVersionPrompted: String? { get set }

    /// A dictionary mapping event names to the number of times they were recorded.
    var eventCounts: [String: Int] { get set }

    /// When `true`, ReviewKit will never show the prompt again.
    var neverAskAgain: Bool { get set }
}

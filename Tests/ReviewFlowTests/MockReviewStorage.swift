import Foundation
@testable import ReviewFlow

// MARK: - MockReviewStorage

/// In-memory ``ReviewStorage`` implementation for testing.
final class MockReviewStorage: ReviewStorage {
    var launchCount: Int = 0
    var firstLaunchDate: Date? = nil
    var lastPromptDate: Date? = nil
    var lastVersionPrompted: String? = nil
    var eventCounts: [String: Int] = [:]
    var neverAskAgain: Bool = false
}

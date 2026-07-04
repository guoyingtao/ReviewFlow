import Foundation

// MARK: - InMemoryReviewStorage

/// A ``ReviewStorage`` implementation that keeps all state in memory.
///
/// Nothing is persisted between app launches, which makes this ideal for:
///
/// - **Unit tests** — fast, isolated, and never touches `UserDefaults`.
/// - **SwiftUI previews** — seed a known state without side effects.
/// - **Debugging** — force a specific eligibility scenario on demand.
///
/// ```swift
/// let storage = InMemoryReviewStorage()
/// storage.launchCount = 10
/// storage.firstLaunchDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
///
/// let manager = ReviewManager(config: .default, storage: storage)
/// ```
public final class InMemoryReviewStorage: ReviewStorage {

    public var launchCount: Int
    public var firstLaunchDate: Date?
    public var lastPromptDate: Date?
    public var lastVersionPrompted: String?
    public var eventCounts: [String: Int]
    public var neverAskAgain: Bool

    /// Creates an in-memory store, optionally seeded with initial values.
    public init(
        launchCount: Int = 0,
        firstLaunchDate: Date? = nil,
        lastPromptDate: Date? = nil,
        lastVersionPrompted: String? = nil,
        eventCounts: [String: Int] = [:],
        neverAskAgain: Bool = false
    ) {
        self.launchCount = launchCount
        self.firstLaunchDate = firstLaunchDate
        self.lastPromptDate = lastPromptDate
        self.lastVersionPrompted = lastVersionPrompted
        self.eventCounts = eventCounts
        self.neverAskAgain = neverAskAgain
    }
}

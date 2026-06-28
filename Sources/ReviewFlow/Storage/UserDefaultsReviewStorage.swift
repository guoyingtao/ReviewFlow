import Foundation

// MARK: - UserDefaultsReviewStorage

/// The default ``ReviewStorage`` implementation backed by `UserDefaults`.
///
/// All reads and writes are serialised through a private `NSLock` so the
/// storage is safe to access from any thread.
///
/// You can supply a custom `suiteName` to keep ReviewFlow's data in a shared
/// App Group container.
///
/// ```swift
/// let storage = UserDefaultsReviewStorage(suiteName: "group.com.example.app")
/// let manager = ReviewManager(config: .default, storage: storage)
/// ```
public final class UserDefaultsReviewStorage: ReviewStorage {

    // MARK: Keys

    private enum Key {
        static let launchCount          = "com.reviewkit.launchCount"
        static let firstLaunchDate      = "com.reviewkit.firstLaunchDate"
        static let lastPromptDate       = "com.reviewkit.lastPromptDate"
        static let lastVersionPrompted  = "com.reviewkit.lastVersionPrompted"
        static let eventCounts          = "com.reviewkit.eventCounts"
        static let neverAskAgain        = "com.reviewkit.neverAskAgain"
    }

    // MARK: Properties

    private let defaults: UserDefaults
    private let lock = NSLock()

    // MARK: Init

    /// Creates a storage instance.
    ///
    /// - Parameter suiteName: An optional App Group suite name.  Pass `nil`
    ///   (the default) to use the app's standard `UserDefaults`.
    public init(suiteName: String? = nil) {
        if let suiteName {
            self.defaults = UserDefaults(suiteName: suiteName) ?? .standard
        } else {
            self.defaults = .standard
        }
    }

    // MARK: ReviewStorage

    public var launchCount: Int {
        get { lock.withLock { defaults.integer(forKey: Key.launchCount) } }
        set { lock.withLock { defaults.set(newValue, forKey: Key.launchCount) } }
    }

    public var firstLaunchDate: Date? {
        get { lock.withLock { defaults.object(forKey: Key.firstLaunchDate) as? Date } }
        set { lock.withLock { defaults.set(newValue, forKey: Key.firstLaunchDate) } }
    }

    public var lastPromptDate: Date? {
        get { lock.withLock { defaults.object(forKey: Key.lastPromptDate) as? Date } }
        set { lock.withLock { defaults.set(newValue, forKey: Key.lastPromptDate) } }
    }

    public var lastVersionPrompted: String? {
        get { lock.withLock { defaults.string(forKey: Key.lastVersionPrompted) } }
        set { lock.withLock { defaults.set(newValue, forKey: Key.lastVersionPrompted) } }
    }

    public var eventCounts: [String: Int] {
        get {
            lock.withLock {
                defaults.dictionary(forKey: Key.eventCounts) as? [String: Int] ?? [:]
            }
        }
        set {
            lock.withLock { defaults.set(newValue, forKey: Key.eventCounts) }
        }
    }

    public var neverAskAgain: Bool {
        get { lock.withLock { defaults.bool(forKey: Key.neverAskAgain) } }
        set { lock.withLock { defaults.set(newValue, forKey: Key.neverAskAgain) } }
    }
}

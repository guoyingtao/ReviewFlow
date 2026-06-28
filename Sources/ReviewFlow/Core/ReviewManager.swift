import Foundation
#if canImport(Combine)
import Combine
#endif

// MARK: - ReviewManager

/// The central coordinator for ReviewFlow.
///
/// `ReviewManager` tracks launches, significant events, and user sentiment,
/// then decides when to surface the review prompt.  It also fires analytics
/// events and delegate callbacks so you can observe every step of the flow.
///
/// ## Typical usage
///
/// ```swift
/// // App entry point
/// @main
/// struct MyApp: App {
///     @StateObject private var reviewManager = ReviewManager(
///         config: ReviewFlowConfig(
///             minLaunchCount: 3,
///             appStoreID: "123456789",
///             feedbackEmail: "support@example.com"
///         )
///     )
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .reviewFlow(manager: reviewManager)
///                 .onAppear { reviewManager.recordLaunch() }
///         }
///     }
/// }
/// ```
@MainActor
public final class ReviewManager {

    // MARK: Shared instance

    /// A pre-configured shared instance using ``ReviewFlowConfig/default``.
    ///
    /// Use this when a single configuration is sufficient for your app.
    public static let shared = ReviewManager()

    // MARK: Published state

    /// `true` while the review prompt overlay is visible.
    #if canImport(Combine)
    @Published public private(set) var isShowingPrompt: Bool = false
    #else
    public private(set) var isShowingPrompt: Bool = false
    #endif

    // MARK: Public properties

    /// The active configuration.
    public let config: ReviewFlowConfig

    /// The underlying storage.
    public let storage: ReviewStorage

    /// Optional closure called for every analytics event ReviewFlow emits.
    ///
    /// ```swift
    /// manager.analyticsHandler = { event in
    ///     MyAnalytics.track(event.name, properties: event.properties)
    /// }
    /// ```
    public var analyticsHandler: (@Sendable (ReviewFlowAnalyticsEvent) -> Void)?

    /// Optional delegate for lifecycle callbacks.
    public weak var delegate: (any ReviewManagerDelegate)?

    // MARK: Private

    private let eligibilityChecker = EligibilityChecker()

    // MARK: Init

    /// Creates a `ReviewManager` with a specific configuration and optional
    /// custom storage backend.
    ///
    /// - Parameters:
    ///   - config: The ``ReviewFlowConfig`` governing prompt behaviour.
    ///   - storage: A custom ``ReviewStorage`` implementation.  Defaults to
    ///     ``UserDefaultsReviewStorage`` backed by the standard `UserDefaults`.
    public init(
        config: ReviewFlowConfig = .default,
        storage: ReviewStorage? = nil
    ) {
        self.config = config
        self.storage = storage ?? UserDefaultsReviewStorage()
    }

    // MARK: Public API

    /// Records a single app launch.
    ///
    /// Call this once per cold-start, typically in your `App` body or
    /// `AppDelegate.applicationDidFinishLaunching`.
    public func recordLaunch() {
        if storage.firstLaunchDate == nil {
            storage.firstLaunchDate = Date()
        }
        storage.launchCount += 1
        delegate?.reviewManager(self, didRecordLaunch: storage.launchCount)
    }

    /// Records a named significant event (e.g. `"ExportCompleted"`).
    ///
    /// Use these events to gate the prompt behind meaningful interactions, by
    /// setting ``ReviewFlowConfig/minimumSignificantEvents`` > 0.
    ///
    /// - Parameter name: An arbitrary event identifier.
    public func recordEvent(_ name: String) {
        var counts = storage.eventCounts
        counts[name, default: 0] += 1
        storage.eventCounts = counts
        delegate?.reviewManager(self, didRecordEvent: name)
    }

    /// Checks eligibility and, if all criteria are met, shows the review prompt.
    ///
    /// Safe to call at any point — it does nothing when the user is not yet
    /// eligible or when a prompt is already visible.
    public func requestReviewIfNeeded() {
        guard !isShowingPrompt else { return }

        let result = eligibilityChecker.evaluate(
            storage: storage,
            config: config,
            currentVersion: currentAppVersion
        )

        if result.isEligible {
            isShowingPrompt = true
            analyticsHandler?(.promptShown)
            delegate?.reviewManagerDidShowPrompt(self)
        } else if let reason = result.failureReason {
            analyticsHandler?(.eligibilityCheckFailed(reason: reason))
        }
    }

    /// Asynchronous variant of ``requestReviewIfNeeded()``.
    ///
    /// Useful when called from a Swift Concurrency context such as a `.task {}`
    /// modifier.
    public func requestReviewIfNeededAsync() async {
        requestReviewIfNeeded()
    }

    /// Resets all persisted state and hides any visible prompt.
    ///
    /// Intended for testing and debugging — not for production use.
    public func reset() {
        storage.launchCount = 0
        storage.firstLaunchDate = nil
        storage.lastPromptDate = nil
        storage.lastVersionPrompted = nil
        storage.eventCounts = [:]
        storage.neverAskAgain = false
        isShowingPrompt = false
    }

    // MARK: Internal — called by UI components

    func handleSentiment(_ sentiment: UserSentiment) {
        analyticsHandler?(.sentimentSelected(sentiment))
        delegate?.reviewManager(self, didReceiveSentiment: sentiment)
    }

    func markPromptShown() {
        storage.lastPromptDate = Date()
        storage.lastVersionPrompted = currentAppVersion
    }

    func markNeverAskAgain() {
        storage.neverAskAgain = true
        dismissPrompt()
    }

    func dismissPrompt() {
        isShowingPrompt = false
        analyticsHandler?(.dismissed)
        delegate?.reviewManagerDidDismissPrompt(self)
    }

    // MARK: Helpers

    var currentAppVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
}

// MARK: - ObservableObject conformance (Apple platforms only)

#if canImport(Combine)
extension ReviewManager: ObservableObject {}
#endif

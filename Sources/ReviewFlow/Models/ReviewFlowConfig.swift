import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif

// MARK: - ReviewFlowConfig

/// The top-level configuration object for ReviewFlow.
///
/// Create a `ReviewFlowConfig` instance to customise every aspect of the review
/// prompt — thresholds, feedback destinations, animations, copy, and
/// appearance — and pass it to ``ReviewManager``.
///
/// ```swift
/// let config = ReviewFlowConfig(
///     minLaunchCount: 3,
///     appStoreID: "123456789",
///     feedbackEmail: "support@example.com"
/// )
/// let manager = ReviewManager(config: config)
/// ```
public struct ReviewFlowConfig: Sendable {

    // MARK: Eligibility thresholds

    /// Minimum number of app launches before the prompt can appear. Default: **5**.
    public var minLaunchCount: Int

    /// Minimum number of days since first launch before the prompt can appear. Default: **3**.
    public var minDaysSinceInstall: Int

    /// Number of days that must elapse between successive prompts. Default: **7**.
    public var cooldownDays: Int

    /// Minimum number of significant events that must be recorded before the
    /// prompt can appear. Set to `0` to ignore this criterion. Default: **0**.
    public var minimumSignificantEvents: Int

    // MARK: Feedback destinations

    /// The email address to which feedback is sent (used to compose a `mailto:` link).
    public var feedbackEmail: String?

    /// A web URL opened when the user chooses "Open Feedback URL".
    public var feedbackURL: URL?

    // MARK: App Store

    /// Your App Store numeric ID. Used to build the App Store rating deep-link.
    /// Example: `"123456789"`.
    public var appStoreID: String?

    // MARK: Experience

    /// Whether spring and fade animations are enabled. Default: **true**.
    public var enableAnimations: Bool

    /// Whether haptic feedback is triggered on user interactions. Default: **true**.
    public var enableHaptics: Bool

    /// Whether to show a "Don't Ask Again" opt-out button on the neutral choice
    /// card. When the user taps it, ReviewFlow never prompts again (until
    /// ``ReviewManager/reset()`` is called). Default: **true**.
    ///
    /// - Note: This option is intentionally *not* offered to negative-sentiment
    ///   users, who may feel differently in a future session.
    public var showNeverAskAgainOption: Bool

    // MARK: Customisation

    /// Localised strings used throughout the review UI.
    public var texts: ReviewFlowTexts

    #if canImport(SwiftUI)
    /// Visual appearance overrides (SwiftUI only).
    public var appearance: ReviewFlowAppearance
    #endif

    // MARK: Default

    /// A `ReviewFlowConfig` with Apple-recommended default values.
    public static let `default` = ReviewFlowConfig()

    // MARK: Init

    #if canImport(SwiftUI)
    public init(
        minLaunchCount: Int = 5,
        minDaysSinceInstall: Int = 3,
        cooldownDays: Int = 7,
        minimumSignificantEvents: Int = 0,
        feedbackEmail: String? = nil,
        feedbackURL: URL? = nil,
        appStoreID: String? = nil,
        enableAnimations: Bool = true,
        enableHaptics: Bool = true,
        showNeverAskAgainOption: Bool = true,
        texts: ReviewFlowTexts = .default,
        appearance: ReviewFlowAppearance = .default
    ) {
        self.minLaunchCount = minLaunchCount
        self.minDaysSinceInstall = minDaysSinceInstall
        self.cooldownDays = cooldownDays
        self.minimumSignificantEvents = minimumSignificantEvents
        self.feedbackEmail = feedbackEmail
        self.feedbackURL = feedbackURL
        self.appStoreID = appStoreID
        self.enableAnimations = enableAnimations
        self.enableHaptics = enableHaptics
        self.showNeverAskAgainOption = showNeverAskAgainOption
        self.texts = texts
        self.appearance = appearance
    }
    #else
    public init(
        minLaunchCount: Int = 5,
        minDaysSinceInstall: Int = 3,
        cooldownDays: Int = 7,
        minimumSignificantEvents: Int = 0,
        feedbackEmail: String? = nil,
        feedbackURL: URL? = nil,
        appStoreID: String? = nil,
        enableAnimations: Bool = true,
        enableHaptics: Bool = true,
        showNeverAskAgainOption: Bool = true,
        texts: ReviewFlowTexts = .default
    ) {
        self.minLaunchCount = minLaunchCount
        self.minDaysSinceInstall = minDaysSinceInstall
        self.cooldownDays = cooldownDays
        self.minimumSignificantEvents = minimumSignificantEvents
        self.feedbackEmail = feedbackEmail
        self.feedbackURL = feedbackURL
        self.appStoreID = appStoreID
        self.enableAnimations = enableAnimations
        self.enableHaptics = enableHaptics
        self.showNeverAskAgainOption = showNeverAskAgainOption
        self.texts = texts
    }
    #endif
}

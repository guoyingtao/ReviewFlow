import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif

// MARK: - ReviewKitConfig

/// The top-level configuration object for ReviewKit.
///
/// Create a `ReviewKitConfig` instance to customise every aspect of the review
/// prompt — thresholds, feedback destinations, animations, copy, and
/// appearance — and pass it to ``ReviewManager``.
///
/// ```swift
/// let config = ReviewKitConfig(
///     minLaunchCount: 3,
///     appStoreID: "123456789",
///     feedbackEmail: "support@example.com"
/// )
/// let manager = ReviewManager(config: config)
/// ```
public struct ReviewKitConfig: Sendable {

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

    // MARK: Customisation

    /// Localised strings used throughout the review UI.
    public var texts: ReviewKitTexts

    #if canImport(SwiftUI)
    /// Visual appearance overrides (SwiftUI only).
    public var appearance: ReviewKitAppearance
    #endif

    // MARK: Default

    /// A `ReviewKitConfig` with Apple-recommended default values.
    public static let `default` = ReviewKitConfig()

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
        texts: ReviewKitTexts = .default,
        appearance: ReviewKitAppearance = .default
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
        texts: ReviewKitTexts = .default
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
        self.texts = texts
    }
    #endif
}

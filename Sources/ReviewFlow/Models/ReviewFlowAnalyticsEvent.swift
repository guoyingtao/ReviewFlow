// MARK: - ReviewFlowDismissReason

/// Why the review prompt was dismissed.
///
/// Accompanies ``ReviewFlowAnalyticsEvent/dismissed(reason:)`` so you can tell
/// completions apart from abandonment in your funnel — e.g. a user who tapped
/// "Later" (``userInitiated``) versus one who proceeded to rate the app
/// (``reviewRequested``).
public enum ReviewFlowDismissReason: String, Sendable {

    /// The user tapped "Later"/"Maybe Later" or the dimmed background.
    case userInitiated

    /// The user proceeded to the native rating prompt / App Store.
    case reviewRequested

    /// The user proceeded to an email or feedback URL.
    case feedbackOpened

    /// The user opted out permanently via "Don't Ask Again".
    case neverAskAgain
}

// MARK: - ReviewFlowAnalyticsEvent

/// Events emitted by ReviewFlow that you can forward to your analytics
/// pipeline by setting ``ReviewManager/analyticsHandler``.
///
/// ```swift
/// manager.analyticsHandler = { event in
///     Analytics.track(event.name, properties: event.properties)
/// }
/// ```
public enum ReviewFlowAnalyticsEvent: Sendable {

    /// The review prompt was shown to the user.
    case promptShown

    /// The user selected a sentiment option.
    case sentimentSelected(UserSentiment)

    /// The system rating dialog was requested via `SKStoreReviewController`.
    case ratingRequested

    /// The user opened an email or URL feedback channel.
    case feedbackOpened

    /// The prompt was dismissed. `reason` distinguishes a completion (the user
    /// went on to rate or send feedback) from abandonment ("Later") or an
    /// explicit opt-out ("Don't Ask Again").
    case dismissed(reason: ReviewFlowDismissReason)

    /// Eligibility check did not pass; `reason` describes why.
    case eligibilityCheckFailed(reason: String)

    // MARK: Convenience

    /// A human-readable event name suitable for analytics platforms.
    public var name: String {
        switch self {
        case .promptShown:            return "review_flow_prompt_shown"
        case .sentimentSelected:      return "review_flow_sentiment_selected"
        case .ratingRequested:        return "review_flow_rating_requested"
        case .feedbackOpened:         return "review_flow_feedback_opened"
        case .dismissed:              return "review_flow_dismissed"
        case .eligibilityCheckFailed: return "review_flow_eligibility_failed"
        }
    }

    /// Optional key/value pairs that accompany the event.
    public var properties: [String: String] {
        switch self {
        case .sentimentSelected(let sentiment):
            return ["sentiment": "\(sentiment)"]
        case .eligibilityCheckFailed(let reason):
            return ["reason": reason]
        case .dismissed(let reason):
            return ["reason": reason.rawValue]
        default:
            return [:]
        }
    }
}

// MARK: - ReviewKitAnalyticsEvent

/// Events emitted by ReviewKit that you can forward to your analytics
/// pipeline by setting ``ReviewManager/analyticsHandler``.
///
/// ```swift
/// manager.analyticsHandler = { event in
///     Analytics.track(event.name, properties: event.properties)
/// }
/// ```
public enum ReviewKitAnalyticsEvent: Sendable {

    /// The review prompt was shown to the user.
    case promptShown

    /// The user selected a sentiment option.
    case sentimentSelected(UserSentiment)

    /// The system rating dialog was requested via `SKStoreReviewController`.
    case ratingRequested

    /// The user opened an email or URL feedback channel.
    case feedbackOpened

    /// The prompt was dismissed without the user completing the flow.
    case dismissed

    /// Eligibility check did not pass; `reason` describes why.
    case eligibilityCheckFailed(reason: String)

    // MARK: Convenience

    /// A human-readable event name suitable for analytics platforms.
    public var name: String {
        switch self {
        case .promptShown:            return "review_kit_prompt_shown"
        case .sentimentSelected:      return "review_kit_sentiment_selected"
        case .ratingRequested:        return "review_kit_rating_requested"
        case .feedbackOpened:         return "review_kit_feedback_opened"
        case .dismissed:              return "review_kit_dismissed"
        case .eligibilityCheckFailed: return "review_kit_eligibility_failed"
        }
    }

    /// Optional key/value pairs that accompany the event.
    public var properties: [String: String] {
        switch self {
        case .sentimentSelected(let sentiment):
            return ["sentiment": "\(sentiment)"]
        case .eligibilityCheckFailed(let reason):
            return ["reason": reason]
        default:
            return [:]
        }
    }
}

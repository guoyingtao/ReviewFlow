// MARK: - UserSentiment

/// The sentiment a user expressed about the app in the review prompt.
public enum UserSentiment: Sendable, Equatable {

    /// The user expressed a positive feeling — "Love it".
    case positive

    /// The user expressed a neutral feeling — "It's OK".
    case neutral

    /// The user expressed a negative feeling — "Needs improvement".
    case negative
}

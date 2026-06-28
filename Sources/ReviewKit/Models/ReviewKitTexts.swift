import Foundation

// MARK: - ReviewKitTexts

/// Localised strings used throughout ReviewKit's UI.
///
/// Override individual strings to match your app's voice and tone, or to
/// provide translations.
///
/// ```swift
/// var texts = ReviewKitTexts.default
/// texts.promptQuestion = "Do you love our app?"
/// let config = ReviewKitConfig(texts: texts)
/// ```
public struct ReviewKitTexts: Sendable {

    // MARK: Sentiment prompt

    /// Title displayed at the top of the sentiment prompt card.
    public var promptTitle: String

    /// Primary question asking the user how they feel about the app.
    public var promptQuestion: String

    /// Button label for positive sentiment.
    public var loveItButton: String

    /// Button label for neutral sentiment.
    public var itsOKButton: String

    /// Button label for negative sentiment.
    public var needsImprovementButton: String

    // MARK: Feedback view

    /// Title of the feedback card shown to unhappy users.
    public var feedbackTitle: String

    /// Subtitle / body copy of the feedback card.
    public var feedbackSubtitle: String

    /// Button label that opens the `mailto:` link.
    public var sendEmailButton: String

    /// Button label that opens the feedback URL.
    public var openFeedbackURLButton: String

    /// Button label that dismisses the prompt without further action.
    public var maybeLaterButton: String

    // MARK: Rate / feedback choice view

    /// Title of the choice card shown to neutral users.
    public var rateChoiceTitle: String

    /// Subtitle of the choice card shown to neutral users.
    public var rateChoiceSubtitle: String

    /// Button label that opens the App Store rating sheet.
    public var rateAppButton: String

    /// Button label that opens the feedback flow.
    public var sendFeedbackButton: String

    /// Button label that defers the decision.
    public var laterButton: String

    // MARK: Default

    /// Default English strings.
    public static let `default` = ReviewKitTexts()

    // MARK: Init

    public init(
        promptTitle: String = "Quick Question",
        promptQuestion: String = "How are you enjoying the app?",
        loveItButton: String = "😊  Love it",
        itsOKButton: String = "😐  It's OK",
        needsImprovementButton: String = "😞  Needs improvement",
        feedbackTitle: String = "We're Sorry to Hear That",
        feedbackSubtitle: String = "We'd love to hear how we can improve.",
        sendEmailButton: String = "Send Email",
        openFeedbackURLButton: String = "Open Feedback URL",
        maybeLaterButton: String = "Maybe Later",
        rateChoiceTitle: String = "Glad you're enjoying it!",
        rateChoiceSubtitle: String = "Would you like to leave a rating or send us feedback?",
        rateAppButton: String = "Rate App",
        sendFeedbackButton: String = "Send Feedback",
        laterButton: String = "Later"
    ) {
        self.promptTitle = promptTitle
        self.promptQuestion = promptQuestion
        self.loveItButton = loveItButton
        self.itsOKButton = itsOKButton
        self.needsImprovementButton = needsImprovementButton
        self.feedbackTitle = feedbackTitle
        self.feedbackSubtitle = feedbackSubtitle
        self.sendEmailButton = sendEmailButton
        self.openFeedbackURLButton = openFeedbackURLButton
        self.maybeLaterButton = maybeLaterButton
        self.rateChoiceTitle = rateChoiceTitle
        self.rateChoiceSubtitle = rateChoiceSubtitle
        self.rateAppButton = rateAppButton
        self.sendFeedbackButton = sendFeedbackButton
        self.laterButton = laterButton
    }
}

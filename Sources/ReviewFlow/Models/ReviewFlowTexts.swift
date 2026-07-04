import Foundation

// MARK: - ReviewFlowTexts

/// Localised strings used throughout ReviewFlow's UI.
///
/// Override individual strings to match your app's voice and tone, or to
/// provide translations.
///
/// ```swift
/// var texts = ReviewFlowTexts.default
/// texts.promptQuestion = "Do you love our app?"
/// let config = ReviewFlowConfig(texts: texts)
/// ```
public struct ReviewFlowTexts: Sendable {

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

    // MARK: Opt-out

    /// Button label that permanently opts the user out of future prompts.
    public var neverAskAgainButton: String

    // MARK: Default

    /// Default strings, localised for the user's current language.
    ///
    /// ReviewFlow ships translations for a range of languages (English, Simplified
    /// & Traditional Chinese, Japanese, Korean, Spanish, French, German,
    /// Portuguese (Brazil), Russian, and Italian). Any language without a
    /// translation falls back to English automatically.
    ///
    /// This is the recommended starting point — copy it and override only the
    /// strings you want to change:
    ///
    /// ```swift
    /// var texts = ReviewFlowTexts.default
    /// texts.promptQuestion = "Do you love our app?"
    /// ```
    ///
    /// - Note: The memberwise ``init(promptTitle:promptQuestion:...)`` uses
    ///   English literals as its defaults; use ``default`` to pick up the
    ///   bundled translations.
    public static let `default` = ReviewFlowTexts(
        promptTitle: localized("review_flow.prompt_title", "Quick Question"),
        promptQuestion: localized("review_flow.prompt_question", "How are you enjoying the app?"),
        loveItButton: localized("review_flow.love_it_button", "😊  Love it"),
        itsOKButton: localized("review_flow.its_ok_button", "😐  It's OK"),
        needsImprovementButton: localized("review_flow.needs_improvement_button", "😞  Needs improvement"),
        feedbackTitle: localized("review_flow.feedback_title", "We're Sorry to Hear That"),
        feedbackSubtitle: localized("review_flow.feedback_subtitle", "We'd love to hear how we can improve."),
        sendEmailButton: localized("review_flow.send_email_button", "Send Email"),
        openFeedbackURLButton: localized("review_flow.open_feedback_url_button", "Open Feedback URL"),
        maybeLaterButton: localized("review_flow.maybe_later_button", "Maybe Later"),
        rateChoiceTitle: localized("review_flow.rate_choice_title", "Glad you're enjoying it!"),
        rateChoiceSubtitle: localized("review_flow.rate_choice_subtitle", "Would you like to leave a rating or send us feedback?"),
        rateAppButton: localized("review_flow.rate_app_button", "Rate App"),
        sendFeedbackButton: localized("review_flow.send_feedback_button", "Send Feedback"),
        laterButton: localized("review_flow.later_button", "Later"),
        neverAskAgainButton: localized("review_flow.never_ask_again_button", "Don't Ask Again")
    )

    // MARK: Localisation helper

    /// Looks up a string in ReviewFlow's bundled String Catalog, falling back to
    /// the supplied English value if no translation is available.
    private static func localized(
        _ key: StaticString,
        _ fallback: String.LocalizationValue
    ) -> String {
        String(localized: key, defaultValue: fallback, bundle: .module)
    }

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
        laterButton: String = "Later",
        neverAskAgainButton: String = "Don't Ask Again"
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
        self.neverAskAgainButton = neverAskAgainButton
    }
}

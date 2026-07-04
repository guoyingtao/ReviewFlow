import XCTest
@testable import ReviewFlow

// MARK: - AnalyticsEventTests

final class AnalyticsEventTests: XCTestCase {

    // MARK: - Event names (public analytics contract)

    func test_eventNames_useReviewFlowPrefix() {
        let events: [ReviewFlowAnalyticsEvent] = [
            .promptShown,
            .sentimentSelected(.positive),
            .ratingRequested,
            .feedbackOpened,
            .dismissed(reason: .userInitiated),
            .eligibilityCheckFailed(reason: "test"),
        ]

        for event in events {
            XCTAssertTrue(
                event.name.hasPrefix("review_flow_"),
                "Expected \(event.name) to use the review_flow_ prefix"
            )
        }
    }

    func test_eventNames_exactValues() {
        XCTAssertEqual(ReviewFlowAnalyticsEvent.promptShown.name, "review_flow_prompt_shown")
        XCTAssertEqual(ReviewFlowAnalyticsEvent.sentimentSelected(.neutral).name, "review_flow_sentiment_selected")
        XCTAssertEqual(ReviewFlowAnalyticsEvent.ratingRequested.name, "review_flow_rating_requested")
        XCTAssertEqual(ReviewFlowAnalyticsEvent.feedbackOpened.name, "review_flow_feedback_opened")
        XCTAssertEqual(ReviewFlowAnalyticsEvent.dismissed(reason: .userInitiated).name, "review_flow_dismissed")
        XCTAssertEqual(ReviewFlowAnalyticsEvent.eligibilityCheckFailed(reason: "x").name, "review_flow_eligibility_failed")
    }

    // MARK: - Properties

    func test_sentimentSelected_carriesSentimentProperty() {
        let event = ReviewFlowAnalyticsEvent.sentimentSelected(.negative)
        XCTAssertEqual(event.properties["sentiment"], "negative")
    }

    func test_eligibilityCheckFailed_carriesReasonProperty() {
        let event = ReviewFlowAnalyticsEvent.eligibilityCheckFailed(reason: "cooldown active")
        XCTAssertEqual(event.properties["reason"], "cooldown active")
    }

    func test_dismissed_carriesReasonProperty() {
        XCTAssertEqual(
            ReviewFlowAnalyticsEvent.dismissed(reason: .reviewRequested).properties["reason"],
            "reviewRequested"
        )
        XCTAssertEqual(
            ReviewFlowAnalyticsEvent.dismissed(reason: .neverAskAgain).properties["reason"],
            "neverAskAgain"
        )
    }
}

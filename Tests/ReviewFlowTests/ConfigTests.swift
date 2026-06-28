import XCTest
@testable import ReviewFlow

// MARK: - ConfigTests

final class ConfigTests: XCTestCase {

    // MARK: - Default values

    func test_defaultConfig_minLaunchCount() {
        XCTAssertEqual(ReviewFlowConfig.default.minLaunchCount, 5)
    }

    func test_defaultConfig_minDaysSinceInstall() {
        XCTAssertEqual(ReviewFlowConfig.default.minDaysSinceInstall, 3)
    }

    func test_defaultConfig_cooldownDays() {
        XCTAssertEqual(ReviewFlowConfig.default.cooldownDays, 7)
    }

    func test_defaultConfig_minimumSignificantEvents() {
        XCTAssertEqual(ReviewFlowConfig.default.minimumSignificantEvents, 0)
    }

    func test_defaultConfig_feedbackEmail_isNil() {
        XCTAssertNil(ReviewFlowConfig.default.feedbackEmail)
    }

    func test_defaultConfig_feedbackURL_isNil() {
        XCTAssertNil(ReviewFlowConfig.default.feedbackURL)
    }

    func test_defaultConfig_appStoreID_isNil() {
        XCTAssertNil(ReviewFlowConfig.default.appStoreID)
    }

    func test_defaultConfig_enableAnimations() {
        XCTAssertTrue(ReviewFlowConfig.default.enableAnimations)
    }

    func test_defaultConfig_enableHaptics() {
        XCTAssertTrue(ReviewFlowConfig.default.enableHaptics)
    }

    // MARK: - Custom values

    func test_customConfig_overridesDefaults() {
        let config = ReviewFlowConfig(
            minLaunchCount: 2,
            minDaysSinceInstall: 1,
            cooldownDays: 14,
            minimumSignificantEvents: 5,
            feedbackEmail: "help@example.com",
            feedbackURL: URL(string: "https://example.com"),
            appStoreID: "999888777",
            enableAnimations: false,
            enableHaptics: false
        )

        XCTAssertEqual(config.minLaunchCount, 2)
        XCTAssertEqual(config.minDaysSinceInstall, 1)
        XCTAssertEqual(config.cooldownDays, 14)
        XCTAssertEqual(config.minimumSignificantEvents, 5)
        XCTAssertEqual(config.feedbackEmail, "help@example.com")
        XCTAssertEqual(config.feedbackURL, URL(string: "https://example.com"))
        XCTAssertEqual(config.appStoreID, "999888777")
        XCTAssertFalse(config.enableAnimations)
        XCTAssertFalse(config.enableHaptics)
    }

    // MARK: - ReviewFlowTexts defaults

    func test_defaultTexts_promptQuestion() {
        XCTAssertEqual(ReviewFlowTexts.default.promptQuestion, "How are you enjoying the app?")
    }

    func test_defaultTexts_loveItButton() {
        XCTAssertFalse(ReviewFlowTexts.default.loveItButton.isEmpty)
    }

    func test_defaultTexts_canBeOverridden() {
        var texts = ReviewFlowTexts.default
        texts.promptQuestion = "Do you love this app?"
        XCTAssertEqual(texts.promptQuestion, "Do you love this app?")
        // Original default is unchanged
        XCTAssertEqual(ReviewFlowTexts.default.promptQuestion, "How are you enjoying the app?")
    }

    // MARK: - ReviewFlowAppearance defaults

    #if canImport(SwiftUI)
    func test_defaultAppearance_cornerRadius() {
        XCTAssertEqual(ReviewFlowAppearance.default.cornerRadius, 20)
    }

    func test_defaultAppearance_cardBackgroundColor_isNil() {
        XCTAssertNil(ReviewFlowAppearance.default.cardBackgroundColor)
    }

    func test_defaultAppearance_scrimOpacity() {
        XCTAssertEqual(ReviewFlowAppearance.default.scrimOpacity, 0.4, accuracy: 0.001)
    }
    #endif
}

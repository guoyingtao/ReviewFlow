import XCTest
@testable import ReviewKit

// MARK: - ConfigTests

final class ConfigTests: XCTestCase {

    // MARK: - Default values

    func test_defaultConfig_minLaunchCount() {
        XCTAssertEqual(ReviewKitConfig.default.minLaunchCount, 5)
    }

    func test_defaultConfig_minDaysSinceInstall() {
        XCTAssertEqual(ReviewKitConfig.default.minDaysSinceInstall, 3)
    }

    func test_defaultConfig_cooldownDays() {
        XCTAssertEqual(ReviewKitConfig.default.cooldownDays, 7)
    }

    func test_defaultConfig_minimumSignificantEvents() {
        XCTAssertEqual(ReviewKitConfig.default.minimumSignificantEvents, 0)
    }

    func test_defaultConfig_feedbackEmail_isNil() {
        XCTAssertNil(ReviewKitConfig.default.feedbackEmail)
    }

    func test_defaultConfig_feedbackURL_isNil() {
        XCTAssertNil(ReviewKitConfig.default.feedbackURL)
    }

    func test_defaultConfig_appStoreID_isNil() {
        XCTAssertNil(ReviewKitConfig.default.appStoreID)
    }

    func test_defaultConfig_enableAnimations() {
        XCTAssertTrue(ReviewKitConfig.default.enableAnimations)
    }

    func test_defaultConfig_enableHaptics() {
        XCTAssertTrue(ReviewKitConfig.default.enableHaptics)
    }

    // MARK: - Custom values

    func test_customConfig_overridesDefaults() {
        let config = ReviewKitConfig(
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

    // MARK: - ReviewKitTexts defaults

    func test_defaultTexts_promptQuestion() {
        XCTAssertEqual(ReviewKitTexts.default.promptQuestion, "How are you enjoying the app?")
    }

    func test_defaultTexts_loveItButton() {
        XCTAssertFalse(ReviewKitTexts.default.loveItButton.isEmpty)
    }

    func test_defaultTexts_canBeOverridden() {
        var texts = ReviewKitTexts.default
        texts.promptQuestion = "Do you love this app?"
        XCTAssertEqual(texts.promptQuestion, "Do you love this app?")
        // Original default is unchanged
        XCTAssertEqual(ReviewKitTexts.default.promptQuestion, "How are you enjoying the app?")
    }

    // MARK: - ReviewKitAppearance defaults

    #if canImport(SwiftUI)
    func test_defaultAppearance_cornerRadius() {
        XCTAssertEqual(ReviewKitAppearance.default.cornerRadius, 20)
    }

    func test_defaultAppearance_cardBackgroundColor_isNil() {
        XCTAssertNil(ReviewKitAppearance.default.cardBackgroundColor)
    }

    func test_defaultAppearance_scrimOpacity() {
        XCTAssertEqual(ReviewKitAppearance.default.scrimOpacity, 0.4, accuracy: 0.001)
    }
    #endif
}

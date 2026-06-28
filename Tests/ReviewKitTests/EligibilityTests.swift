import XCTest
@testable import ReviewKit

// MARK: - EligibilityTests

final class EligibilityTests: XCTestCase {

    private var checker: EligibilityChecker!
    private var storage: MockReviewStorage!
    private var config: ReviewKitConfig!
    private let version = "1.0"

    override func setUp() {
        super.setUp()
        checker = EligibilityChecker()
        storage = MockReviewStorage()
        config = ReviewKitConfig(
            minLaunchCount: 5,
            minDaysSinceInstall: 3,
            cooldownDays: 7,
            minimumSignificantEvents: 0
        )
    }

    // MARK: - neverAskAgain

    func test_neverAskAgain_blocksEligibility() {
        storage.neverAskAgain = true
        storage.launchCount = 100
        storage.firstLaunchDate = daysAgo(10)

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertFalse(result.isEligible)
        XCTAssertEqual(result.failureReason, "neverAskAgain is set")
    }

    // MARK: - Launch count

    func test_insufficientLaunches_blocksEligibility() {
        storage.launchCount = 4
        storage.firstLaunchDate = daysAgo(10)

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertFalse(result.isEligible)
        XCTAssertTrue(result.failureReason?.contains("Launch count") == true)
    }

    func test_exactMinimumLaunches_passes() {
        storage.launchCount = 5
        storage.firstLaunchDate = daysAgo(10)

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertTrue(result.isEligible)
    }

    // MARK: - Days since install

    func test_tooRecentInstall_blocksEligibility() {
        storage.launchCount = 10
        storage.firstLaunchDate = daysAgo(1)   // 1 day, minimum is 3

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertFalse(result.isEligible)
        XCTAssertTrue(result.failureReason?.contains("day(s) since install") == true)
    }

    func test_sufficientDaysSinceInstall_passes() {
        storage.launchCount = 10
        storage.firstLaunchDate = daysAgo(5)

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertTrue(result.isEligible)
    }

    // MARK: - Cooldown

    func test_withinCooldownPeriod_blocksEligibility() {
        storage.launchCount = 10
        storage.firstLaunchDate = daysAgo(10)
        storage.lastPromptDate = daysAgo(3)    // 3 days ago, cooldown is 7

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertFalse(result.isEligible)
        XCTAssertTrue(result.failureReason?.contains("Cooldown") == true)
    }

    func test_afterCooldownExpiry_passes() {
        storage.launchCount = 10
        storage.firstLaunchDate = daysAgo(10)
        storage.lastPromptDate = daysAgo(8)    // 8 days ago, cooldown is 7

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertTrue(result.isEligible)
    }

    // MARK: - Version deduplication

    func test_sameVersionAlreadyPrompted_blocksEligibility() {
        storage.launchCount = 10
        storage.firstLaunchDate = daysAgo(10)
        storage.lastVersionPrompted = version

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertFalse(result.isEligible)
        XCTAssertTrue(result.failureReason?.contains("Already prompted for version") == true)
    }

    func test_differentVersion_passes() {
        storage.launchCount = 10
        storage.firstLaunchDate = daysAgo(10)
        storage.lastVersionPrompted = "0.9"   // previous version

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertTrue(result.isEligible)
    }

    // MARK: - Significant events

    func test_insufficientSignificantEvents_blocksEligibility() {
        config = ReviewKitConfig(
            minLaunchCount: 5,
            minDaysSinceInstall: 3,
            cooldownDays: 7,
            minimumSignificantEvents: 3
        )
        storage.launchCount = 10
        storage.firstLaunchDate = daysAgo(10)
        storage.eventCounts = ["Export": 1]   // 1 event, minimum is 3

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertFalse(result.isEligible)
        XCTAssertTrue(result.failureReason?.contains("Insufficient significant events") == false ||
                      result.failureReason?.contains("minimum") == true)
    }

    func test_sufficientSignificantEvents_passes() {
        config = ReviewKitConfig(
            minLaunchCount: 5,
            minDaysSinceInstall: 3,
            cooldownDays: 7,
            minimumSignificantEvents: 3
        )
        storage.launchCount = 10
        storage.firstLaunchDate = daysAgo(10)
        storage.eventCounts = ["Export": 2, "Share": 1]   // 3 total

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertTrue(result.isEligible)
    }

    func test_zeroMinimumSignificantEvents_ignored() {
        config = ReviewKitConfig(minimumSignificantEvents: 0)
        storage.launchCount = 10
        storage.firstLaunchDate = daysAgo(10)
        storage.eventCounts = [:]

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertTrue(result.isEligible)
    }

    // MARK: - All conditions met

    func test_allConditionsMet_isEligible() {
        storage.launchCount = 10
        storage.firstLaunchDate = daysAgo(10)
        storage.lastPromptDate = daysAgo(8)
        storage.lastVersionPrompted = "0.9"
        storage.neverAskAgain = false

        let result = checker.evaluate(storage: storage, config: config, currentVersion: version)

        XCTAssertTrue(result.isEligible)
        XCTAssertNil(result.failureReason)
    }

    // MARK: - Helpers

    private func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
    }
}

import XCTest
@testable import ReviewFlow

// MARK: - ReviewManagerTests

#if canImport(Combine)

@MainActor
final class ReviewManagerTests: XCTestCase {

    private var manager: ReviewManager!
    private var storage: MockReviewStorage!

    override func setUp() {
        super.setUp()
        storage = MockReviewStorage()
        manager = ReviewManager(
            config: ReviewFlowConfig(
                minLaunchCount: 5,
                minDaysSinceInstall: 3,
                cooldownDays: 7
            ),
            storage: storage
        )
    }

    // MARK: - recordLaunch

    func test_recordLaunch_incrementsCount() {
        manager.recordLaunch()
        XCTAssertEqual(storage.launchCount, 1)
        manager.recordLaunch()
        XCTAssertEqual(storage.launchCount, 2)
    }

    func test_recordLaunch_setsFirstLaunchDate() {
        XCTAssertNil(storage.firstLaunchDate)
        manager.recordLaunch()
        XCTAssertNotNil(storage.firstLaunchDate)
    }

    func test_recordLaunch_doesNotOverwriteFirstLaunchDate() {
        let original = Date(timeIntervalSinceNow: -1_000)
        storage.firstLaunchDate = original
        manager.recordLaunch()
        XCTAssertEqual(
            storage.firstLaunchDate?.timeIntervalSince1970 ?? .nan,
            original.timeIntervalSince1970,
            accuracy: 0.001
        )
    }

    // MARK: - recordEvent

    func test_recordEvent_incrementsCount() {
        manager.recordEvent("Export")
        XCTAssertEqual(storage.eventCounts["Export"], 1)
        manager.recordEvent("Export")
        XCTAssertEqual(storage.eventCounts["Export"], 2)
    }

    func test_recordEvent_tracksMultipleEvents() {
        manager.recordEvent("Export")
        manager.recordEvent("Share")
        manager.recordEvent("Share")
        XCTAssertEqual(storage.eventCounts["Export"], 1)
        XCTAssertEqual(storage.eventCounts["Share"], 2)
    }

    // MARK: - requestReviewIfNeeded

    func test_requestReviewIfNeeded_doesNotShowWhenIneligible() {
        // Launch count is 0 — not eligible
        manager.requestReviewIfNeeded()
        XCTAssertFalse(manager.isShowingPrompt)
    }

    func test_requestReviewIfNeeded_showsPromptWhenEligible() {
        makeEligible()
        manager.requestReviewIfNeeded()
        XCTAssertTrue(manager.isShowingPrompt)
    }

    func test_requestReviewIfNeeded_doesNotShowTwice() {
        makeEligible()
        manager.requestReviewIfNeeded()
        XCTAssertTrue(manager.isShowingPrompt)
        // Calling again while showing should be a no-op
        manager.requestReviewIfNeeded()
        XCTAssertTrue(manager.isShowingPrompt) // still showing, not reset
    }

    func test_requestReviewIfNeeded_firesAnalyticsWhenEligible() {
        makeEligible()
        var received: [ReviewFlowAnalyticsEvent] = []
        manager.analyticsHandler = { received.append($0) }

        manager.requestReviewIfNeeded()

        XCTAssertEqual(received.count, 1)
        if case .promptShown = received[0] { } else {
            XCTFail("Expected .promptShown, got \(received[0])")
        }
    }

    func test_requestReviewIfNeeded_firesEligibilityFailedWhenIneligible() {
        // storage is empty → ineligible
        var received: [ReviewFlowAnalyticsEvent] = []
        manager.analyticsHandler = { received.append($0) }

        manager.requestReviewIfNeeded()

        XCTAssertEqual(received.count, 1)
        if case .eligibilityCheckFailed = received[0] { } else {
            XCTFail("Expected .eligibilityCheckFailed, got \(received[0])")
        }
    }

    // MARK: - reset

    func test_reset_clearsAllState() {
        makeEligible()
        manager.requestReviewIfNeeded()

        manager.reset()

        XCTAssertEqual(storage.launchCount, 0)
        XCTAssertNil(storage.firstLaunchDate)
        XCTAssertNil(storage.lastPromptDate)
        XCTAssertNil(storage.lastVersionPrompted)
        XCTAssertTrue(storage.eventCounts.isEmpty)
        XCTAssertFalse(storage.neverAskAgain)
        XCTAssertFalse(manager.isShowingPrompt)
    }

    // MARK: - markNeverAskAgain

    func test_markNeverAskAgain_setsFlagAndHidesPrompt() {
        makeEligible()
        manager.requestReviewIfNeeded()
        XCTAssertTrue(manager.isShowingPrompt)

        manager.markNeverAskAgain()

        XCTAssertTrue(storage.neverAskAgain)
        XCTAssertFalse(manager.isShowingPrompt)
    }

    // MARK: - dismissPrompt

    func test_dismissPrompt_hidesOverlay() {
        makeEligible()
        manager.requestReviewIfNeeded()
        XCTAssertTrue(manager.isShowingPrompt)

        manager.dismissPrompt()

        XCTAssertFalse(manager.isShowingPrompt)
    }

    func test_dismissPrompt_firesAnalyticsEvent() {
        makeEligible()
        manager.requestReviewIfNeeded()

        var received: [ReviewFlowAnalyticsEvent] = []
        manager.analyticsHandler = { received.append($0) }

        manager.dismissPrompt()

        XCTAssertEqual(received.count, 1)
        if case .dismissed = received[0] { } else {
            XCTFail("Expected .dismissed, got \(received[0])")
        }
    }

    // MARK: - markPromptShown

    func test_markPromptShown_setsLastPromptDate() {
        XCTAssertNil(storage.lastPromptDate)
        manager.markPromptShown()
        XCTAssertNotNil(storage.lastPromptDate)
    }

    // MARK: - neverAskAgain prevents subsequent prompts

    func test_neverAskAgain_preventsSubsequentPrompt() {
        makeEligible()
        storage.neverAskAgain = true
        manager.requestReviewIfNeeded()
        XCTAssertFalse(manager.isShowingPrompt)
    }

    // MARK: - Delegate

    func test_delegate_calledOnLaunch() {
        let delegate = SpyDelegate()
        manager.delegate = delegate
        manager.recordLaunch()
        XCTAssertEqual(delegate.launchCount, 1)
    }

    func test_delegate_calledOnEvent() {
        let delegate = SpyDelegate()
        manager.delegate = delegate
        manager.recordEvent("Purchase")
        XCTAssertEqual(delegate.lastEvent, "Purchase")
    }

    // MARK: - Helpers

    private func makeEligible() {
        storage.launchCount = 10
        storage.firstLaunchDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
        storage.lastPromptDate = nil
        storage.lastVersionPrompted = nil
        storage.neverAskAgain = false
    }
}

// MARK: - SpyDelegate

private final class SpyDelegate: ReviewManagerDelegate {
    var launchCount: Int = 0
    var lastEvent: String?
    var lastSentiment: UserSentiment?

    func reviewManager(_ manager: ReviewManager, didRecordLaunch count: Int) {
        launchCount = count
    }

    func reviewManager(_ manager: ReviewManager, didRecordEvent name: String) {
        lastEvent = name
    }

    func reviewManager(_ manager: ReviewManager, didReceiveSentiment sentiment: UserSentiment) {
        lastSentiment = sentiment
    }
}

#endif // canImport(Combine)

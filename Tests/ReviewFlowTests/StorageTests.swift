import XCTest
@testable import ReviewFlow

// MARK: - StorageTests

/// Tests for ``UserDefaultsReviewStorage`` using an isolated suite name so
/// they don't pollute the standard UserDefaults.
final class StorageTests: XCTestCase {

    private var storage: UserDefaultsReviewStorage!
    private let suiteName = "com.reviewkit.tests.\(UUID().uuidString)"

    override func setUp() {
        super.setUp()
        storage = UserDefaultsReviewStorage(suiteName: suiteName)
    }

    override func tearDown() {
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    // MARK: - launchCount

    func test_launchCount_defaultsToZero() {
        XCTAssertEqual(storage.launchCount, 0)
    }

    func test_launchCount_persistsValue() {
        storage.launchCount = 42
        XCTAssertEqual(storage.launchCount, 42)
    }

    func test_launchCount_increment() {
        storage.launchCount = 0
        storage.launchCount += 1
        storage.launchCount += 1
        XCTAssertEqual(storage.launchCount, 2)
    }

    // MARK: - firstLaunchDate

    func test_firstLaunchDate_defaultsToNil() {
        XCTAssertNil(storage.firstLaunchDate)
    }

    func test_firstLaunchDate_roundtrips() throws {
        let date = Date(timeIntervalSince1970: 1_000_000)
        storage.firstLaunchDate = date
        let stored = try XCTUnwrap(storage.firstLaunchDate)
        XCTAssertEqual(stored.timeIntervalSince1970, date.timeIntervalSince1970, accuracy: 0.001)
    }

    func test_firstLaunchDate_canBeNilledOut() {
        storage.firstLaunchDate = Date()
        storage.firstLaunchDate = nil
        XCTAssertNil(storage.firstLaunchDate)
    }

    // MARK: - lastPromptDate

    func test_lastPromptDate_defaultsToNil() {
        XCTAssertNil(storage.lastPromptDate)
    }

    func test_lastPromptDate_roundtrips() throws {
        let date = Date()
        storage.lastPromptDate = date
        let stored = try XCTUnwrap(storage.lastPromptDate)
        XCTAssertEqual(
            stored.timeIntervalSinceReferenceDate,
            date.timeIntervalSinceReferenceDate,
            accuracy: 0.001
        )
    }

    // MARK: - lastVersionPrompted

    func test_lastVersionPrompted_defaultsToNil() {
        XCTAssertNil(storage.lastVersionPrompted)
    }

    func test_lastVersionPrompted_roundtrips() {
        storage.lastVersionPrompted = "2.3.4"
        XCTAssertEqual(storage.lastVersionPrompted, "2.3.4")
    }

    // MARK: - eventCounts

    func test_eventCounts_defaultsToEmpty() {
        XCTAssertTrue(storage.eventCounts.isEmpty)
    }

    func test_eventCounts_roundtrips() {
        storage.eventCounts = ["Export": 3, "Share": 1]
        XCTAssertEqual(storage.eventCounts["Export"], 3)
        XCTAssertEqual(storage.eventCounts["Share"], 1)
    }

    func test_eventCounts_increment() {
        storage.eventCounts = [:]
        var counts = storage.eventCounts
        counts["Export", default: 0] += 1
        counts["Export", default: 0] += 1
        storage.eventCounts = counts
        XCTAssertEqual(storage.eventCounts["Export"], 2)
    }

    // MARK: - neverAskAgain

    func test_neverAskAgain_defaultsToFalse() {
        XCTAssertFalse(storage.neverAskAgain)
    }

    func test_neverAskAgain_canBeSetToTrue() {
        storage.neverAskAgain = true
        XCTAssertTrue(storage.neverAskAgain)
    }

    func test_neverAskAgain_canBeReset() {
        storage.neverAskAgain = true
        storage.neverAskAgain = false
        XCTAssertFalse(storage.neverAskAgain)
    }
}

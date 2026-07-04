import Foundation
@testable import ReviewFlow

// MARK: - MockReviewStorage

/// Test alias for the library's public ``InMemoryReviewStorage``.
///
/// Kept as a typealias so existing tests continue to compile while there is a
/// single in-memory storage implementation to maintain.
typealias MockReviewStorage = InMemoryReviewStorage

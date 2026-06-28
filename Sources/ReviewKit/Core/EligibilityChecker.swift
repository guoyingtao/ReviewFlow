import Foundation

// MARK: - EligibilityChecker

/// Determines whether the review prompt should be shown given the current
/// storage state and configuration.
struct EligibilityChecker {

    // MARK: Result

    struct Result {
        let isEligible: Bool
        let failureReason: String?
    }

    // MARK: Evaluation

    /// Evaluates eligibility against all configured rules.
    ///
    /// - Parameters:
    ///   - storage: The current persisted state.
    ///   - config: The active ``ReviewKitConfig``.
    ///   - currentVersion: The running app version string.
    /// - Returns: An ``EligibilityChecker/Result`` describing the outcome.
    func evaluate(
        storage: ReviewStorage,
        config: ReviewKitConfig,
        currentVersion: String
    ) -> Result {

        // 1. Respect "Never Ask Again"
        if storage.neverAskAgain {
            return .init(isEligible: false, failureReason: "neverAskAgain is set")
        }

        // 2. Launch count threshold
        guard storage.launchCount >= config.minLaunchCount else {
            return .init(
                isEligible: false,
                failureReason: "Launch count \(storage.launchCount) < minimum \(config.minLaunchCount)"
            )
        }

        // 3. Days since first launch
        if let firstLaunch = storage.firstLaunchDate {
            let daysSinceInstall = Calendar.current.dateComponents(
                [.day], from: firstLaunch, to: Date()
            ).day ?? 0

            guard daysSinceInstall >= config.minDaysSinceInstall else {
                return .init(
                    isEligible: false,
                    failureReason: "Only \(daysSinceInstall) day(s) since install; minimum is \(config.minDaysSinceInstall)"
                )
            }
        }

        // 4. Cooldown period
        if let lastPrompt = storage.lastPromptDate {
            let daysSinceLastPrompt = Calendar.current.dateComponents(
                [.day], from: lastPrompt, to: Date()
            ).day ?? 0

            guard daysSinceLastPrompt >= config.cooldownDays else {
                return .init(
                    isEligible: false,
                    failureReason: "Cooldown active; \(daysSinceLastPrompt) of \(config.cooldownDays) day(s) elapsed"
                )
            }
        }

        // 5. Version deduplication — don't prompt twice for the same build
        if let lastVersion = storage.lastVersionPrompted, lastVersion == currentVersion {
            return .init(
                isEligible: false,
                failureReason: "Already prompted for version \(currentVersion)"
            )
        }

        // 6. Significant events threshold
        if config.minimumSignificantEvents > 0 {
            let totalEvents = storage.eventCounts.values.reduce(0, +)
            guard totalEvents >= config.minimumSignificantEvents else {
                return .init(
                    isEligible: false,
                    failureReason: "Recorded \(totalEvents) event(s); minimum is \(config.minimumSignificantEvents)"
                )
            }
        }

        return .init(isEligible: true, failureReason: nil)
    }
}

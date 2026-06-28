/// ReviewKit Demo App
///
/// This file shows how to integrate ReviewKit into a SwiftUI application.
/// Copy the patterns that match your use case.
///
/// To run this demo:
/// 1. Create a new Xcode project (iOS App, SwiftUI interface)
/// 2. Add ReviewKit via File > Add Package Dependencies
/// 3. Replace your App and ContentView files with the code below

#if canImport(SwiftUI)
import SwiftUI
import ReviewKit

// MARK: - App entry point

/*

@main
struct ReviewKitDemoApp: App {

    /// Create one ReviewManager for the lifetime of the app.
    /// StateObject ensures it's not recreated on re-renders.
    @StateObject private var reviewManager = ReviewManager(
        config: ReviewKitConfig(
            minLaunchCount: 3,          // Show after 3 launches
            minDaysSinceInstall: 1,     // And at least 1 day after install
            cooldownDays: 14,           // Wait 14 days between prompts
            minimumSignificantEvents: 2, // Require 2 significant events
            appStoreID: "123456789",    // Your App Store numeric ID
            feedbackEmail: "support@yourapp.com",
            feedbackURL: URL(string: "https://yourapp.com/feedback"),
            enableAnimations: true,
            enableHaptics: true,
            texts: customTexts,
            appearance: customAppearance
        )
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Attach the overlay to the root view
                .reviewKit(manager: reviewManager)
                .onAppear {
                    // Record each cold launch
                    reviewManager.recordLaunch()
                }
        }
    }

    // Forward analytics events to your own system
    private func setupAnalytics() {
        reviewManager.analyticsHandler = { event in
            print("[ReviewKit]", event.name, event.properties)
            // MyAnalytics.track(event.name, properties: event.properties)
        }
    }
}

*/

// MARK: - Content View

/*

struct ContentView: View {

    @EnvironmentObject private var reviewManager: ReviewManager

    var body: some View {
        NavigationStack {
            List {
                Section("Simulate Usage") {
                    Button("Record Launch") {
                        reviewManager.recordLaunch()
                    }

                    Button("Record Significant Event") {
                        reviewManager.recordEvent("ExportCompleted")
                    }

                    Button("Request Review If Needed") {
                        reviewManager.requestReviewIfNeeded()
                    }
                }

                Section("Debug") {
                    Button("Force Show Prompt") {
                        // For testing — bypass eligibility
                        reviewManager.reset()
                        // Directly set eligible state
                        reviewManager.storage.launchCount = 100
                        reviewManager.storage.firstLaunchDate = Date(timeIntervalSinceNow: -86400 * 10)
                        reviewManager.requestReviewIfNeeded()
                    }

                    Button("Reset All State", role: .destructive) {
                        reviewManager.reset()
                    }
                }

                Section("Current State") {
                    LabeledContent("Launch Count", value: "\(reviewManager.storage.launchCount)")
                    LabeledContent("Never Ask Again", value: reviewManager.storage.neverAskAgain ? "Yes" : "No")
                }
            }
            .navigationTitle("ReviewKit Demo")
        }
    }
}

*/

// MARK: - Custom texts example

let customTexts = ReviewKitTexts(
    promptTitle: "Enjoying the app?",
    promptQuestion: "We'd love to hear your feedback.",
    loveItButton: "❤️  Love it!",
    itsOKButton: "🤔  It's alright",
    needsImprovementButton: "😞  Needs work",
    feedbackTitle: "Tell us more",
    feedbackSubtitle: "Your feedback helps us improve.",
    maybeLaterButton: "Not now",
    laterButton: "Skip for now"
)

// MARK: - Custom appearance example

let customAppearance = ReviewKitAppearance(
    cornerRadius: 28,
    titleFont: .title3.bold(),
    bodyFont: .callout,
    buttonFont: .callout,
    accentColor: .purple,
    scrimOpacity: 0.5
)

// MARK: - Analytics integration example

/*

// Mixpanel example
reviewManager.analyticsHandler = { event in
    Mixpanel.mainInstance().track(
        event: event.name,
        properties: event.properties
    )
}

// Firebase example
reviewManager.analyticsHandler = { event in
    Analytics.logEvent(event.name, parameters: event.properties)
}

*/

// MARK: - Async / Swift Concurrency example

/*

.task {
    // Record a significant event after async work completes
    let result = await performExpensiveOperation()
    if result.isSuccess {
        reviewManager.recordEvent("OperationCompleted")
        await reviewManager.requestReviewIfNeededAsync()
    }
}

*/

// MARK: - Custom storage backend example

/*

/// Example: Keychain-backed storage (skeleton)
final class KeychainReviewStorage: ReviewStorage {
    var launchCount: Int {
        get { Keychain.integer(forKey: "rkLaunchCount") ?? 0 }
        set { Keychain.set(newValue, forKey: "rkLaunchCount") }
    }
    // ... implement other properties similarly
}

let manager = ReviewManager(
    config: .default,
    storage: KeychainReviewStorage()
)

*/

#endif

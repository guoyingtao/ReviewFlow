import SwiftUI
import ReviewFlow

@main
struct ReviewFlowDemoApp: App {

    @StateObject private var reviewManager = ReviewManager(
        config: ReviewFlowConfig(
            minLaunchCount: 1,
            minDaysSinceInstall: 0,
            cooldownDays: 1,
            minimumSignificantEvents: 0,
            appStoreID: nil,
            feedbackEmail: "support@example.com",
            feedbackURL: URL(string: "https://example.com/feedback")
        )
    )

    var body: some Scene {
        WindowGroup {
            ContentView(reviewManager: reviewManager)
                .reviewFlow(manager: reviewManager)
                .onAppear {
                    reviewManager.recordLaunch()
                }
        }
    }
}

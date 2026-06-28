import SwiftUI
import ReviewFlow

struct ContentView: View {

    @ObservedObject var reviewManager: ReviewManager

    var body: some View {
        NavigationStack {
            List {
                simulateSection
                debugSection
                stateSection
            }
            .navigationTitle("ReviewFlow Demo")
        }
    }

    // MARK: - Simulate Usage

    private var simulateSection: some View {
        Section("Simulate Usage") {
            Button("Record Launch") {
                reviewManager.recordLaunch()
            }

            Button("Record Significant Event") {
                reviewManager.recordEvent("DemoEventTriggered")
            }

            Button("Request Review If Needed") {
                reviewManager.requestReviewIfNeeded()
            }
        }
    }

    // MARK: - Debug

    private var debugSection: some View {
        Section("Debug") {
            Button("Force Show Prompt") {
                reviewManager.reset()
                reviewManager.storage.launchCount = 100
                reviewManager.storage.firstLaunchDate = Date(timeIntervalSinceNow: -86_400 * 10)
                reviewManager.requestReviewIfNeeded()
            }

            Button("Reset All State", role: .destructive) {
                reviewManager.reset()
            }
        }
    }

    // MARK: - Current State

    private var stateSection: some View {
        Section("Current State") {
            LabeledContent("Launch Count") {
                Text("\(reviewManager.storage.launchCount)")
                    .foregroundStyle(.secondary)
            }
            LabeledContent("Days Since Install") {
                Text(daysSinceInstall)
                    .foregroundStyle(.secondary)
            }
            LabeledContent("Never Ask Again") {
                Text(reviewManager.storage.neverAskAgain ? "Yes" : "No")
                    .foregroundStyle(.secondary)
            }
            LabeledContent("Prompt Showing") {
                Text(reviewManager.isShowingPrompt ? "Yes" : "No")
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Helpers

    private var daysSinceInstall: String {
        guard let first = reviewManager.storage.firstLaunchDate else { return "—" }
        let days = Calendar.current.dateComponents([.day], from: first, to: Date()).day ?? 0
        return "\(days)"
    }
}

#Preview {
    ContentView(reviewManager: ReviewManager())
}

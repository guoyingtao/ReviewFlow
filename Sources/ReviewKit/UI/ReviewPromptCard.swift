#if canImport(SwiftUI)
import SwiftUI

// MARK: - ReviewPromptCard

/// The initial card asking the user how they feel about the app.
struct ReviewPromptCard: View {

    @EnvironmentObject private var manager: ReviewManager
    let onSentiment: (UserSentiment) -> Void

    var body: some View {
        VStack(spacing: 24) {

            // Header
            VStack(spacing: 8) {
                Text(manager.config.texts.promptTitle)
                    .font(manager.config.appearance.titleFont)
                    .foregroundStyle(.primary)

                Text(manager.config.texts.promptQuestion)
                    .font(manager.config.appearance.bodyFont)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Sentiment buttons
            VStack(spacing: 12) {
                sentimentButton(
                    title: manager.config.texts.loveItButton,
                    sentiment: .positive,
                    color: .green
                )
                sentimentButton(
                    title: manager.config.texts.itsOKButton,
                    sentiment: .neutral,
                    color: .orange
                )
                sentimentButton(
                    title: manager.config.texts.needsImprovementButton,
                    sentiment: .negative,
                    color: .red
                )
            }
        }
        .reviewCard(
            cornerRadius: manager.config.appearance.cornerRadius,
            backgroundColor: manager.config.appearance.cardBackgroundColor
        )
    }

    @ViewBuilder
    private func sentimentButton(
        title: String,
        sentiment: UserSentiment,
        color: Color
    ) -> some View {
        Button {
            if manager.config.enableHaptics {
                HapticManager.selection()
            }
            onSentiment(sentiment)
        } label: {
            Text(title)
                .font(manager.config.appearance.buttonFont)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(color.opacity(0.12))
                .foregroundStyle(color)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    ReviewPromptCard { _ in }
        .environmentObject(ReviewManager())
        .padding()
}
#endif
#endif

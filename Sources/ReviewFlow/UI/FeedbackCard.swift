#if canImport(SwiftUI)
import SwiftUI

// MARK: - FeedbackCard

/// Shown to unhappy users, offering email and URL feedback channels.
struct FeedbackCard: View {

    @EnvironmentObject private var manager: ReviewManager
    let onEmail: () -> Void
    let onFeedbackURL: () -> Void
    let onLater: () -> Void

    private var hasEmail: Bool { manager.config.feedbackEmail != nil }
    private var hasFeedbackURL: Bool { manager.config.feedbackURL != nil }

    var body: some View {
        VStack(spacing: 24) {

            // Header
            VStack(spacing: 8) {
                Image(systemName: "heart.slash")
                    .font(.system(size: 36))
                    .foregroundStyle(manager.config.appearance.accentColor)
                    .accessibilityHidden(true)

                Text(manager.config.texts.feedbackTitle)
                    .font(manager.config.appearance.titleFont)
                    .foregroundStyle(.primary)

                Text(manager.config.texts.feedbackSubtitle)
                    .font(manager.config.appearance.bodyFont)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Actions
            VStack(spacing: 12) {
                if hasEmail {
                    primaryButton(
                        title: manager.config.texts.sendEmailButton,
                        systemImage: "envelope.fill",
                        action: {
                            if manager.config.enableHaptics { HapticManager.impact(.medium) }
                            onEmail()
                        }
                    )
                }

                if hasFeedbackURL {
                    secondaryButton(
                        title: manager.config.texts.openFeedbackURLButton,
                        systemImage: "safari",
                        action: {
                            if manager.config.enableHaptics { HapticManager.selection() }
                            onFeedbackURL()
                        }
                    )
                }

                laterButton
            }
        }
        .reviewCard(
            cornerRadius: manager.config.appearance.cornerRadius,
            backgroundColor: manager.config.appearance.cardBackgroundColor
        )
    }

    // MARK: Subviews

    private func primaryButton(
        title: String,
        systemImage: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(manager.config.appearance.buttonFont.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(manager.config.appearance.accentColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func secondaryButton(
        title: String,
        systemImage: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(manager.config.appearance.buttonFont)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(Color.secondary.opacity(0.12))
                .foregroundStyle(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var laterButton: some View {
        Button {
            if manager.config.enableHaptics { HapticManager.selection() }
            onLater()
        } label: {
            Text(manager.config.texts.maybeLaterButton)
                .font(manager.config.appearance.bodyFont)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    FeedbackCard(onEmail: {}, onFeedbackURL: {}, onLater: {})
        .environmentObject(ReviewManager(config: ReviewFlowConfig(
            feedbackEmail: "support@example.com",
            feedbackURL: URL(string: "https://example.com/feedback")
        )))
        .padding()
}
#endif
#endif

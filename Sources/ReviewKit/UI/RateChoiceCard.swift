#if canImport(SwiftUI)
import SwiftUI

// MARK: - RateChoiceCard

/// Shown to neutral users, offering them a choice between leaving a rating
/// or submitting feedback.
struct RateChoiceCard: View {

    @EnvironmentObject private var manager: ReviewManager
    let onRate: () -> Void
    let onFeedback: () -> Void
    let onLater: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            // Header
            VStack(spacing: 8) {
                Text(manager.config.texts.rateChoiceTitle)
                    .font(manager.config.appearance.titleFont)
                    .foregroundStyle(.primary)

                Text(manager.config.texts.rateChoiceSubtitle)
                    .font(manager.config.appearance.bodyFont)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Actions
            VStack(spacing: 12) {
                primaryButton(
                    title: manager.config.texts.rateAppButton,
                    systemImage: "star.fill",
                    color: manager.config.appearance.accentColor
                ) {
                    if manager.config.enableHaptics { HapticManager.impact(.medium) }
                    onRate()
                }

                secondaryButton(
                    title: manager.config.texts.sendFeedbackButton,
                    systemImage: "envelope"
                ) {
                    if manager.config.enableHaptics { HapticManager.selection() }
                    onFeedback()
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
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(manager.config.appearance.buttonFont.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(color)
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
            Text(manager.config.texts.laterButton)
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
    RateChoiceCard(onRate: {}, onFeedback: {}, onLater: {})
        .environmentObject(ReviewManager())
        .padding()
}
#endif
#endif

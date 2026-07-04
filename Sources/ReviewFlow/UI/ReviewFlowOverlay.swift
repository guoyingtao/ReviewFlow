#if canImport(SwiftUI)
import SwiftUI
#if canImport(StoreKit)
import StoreKit
#endif
#if os(iOS)
import UIKit
#endif
#if os(macOS)
import AppKit
#endif

// MARK: - ReviewFlowOverlay

/// The full-screen overlay that manages the complete review prompt flow.
///
/// Injected automatically by ``ReviewFlowModifier`` — you do not need to use
/// this view directly.
struct ReviewFlowOverlay: View {

    @EnvironmentObject private var manager: ReviewManager
    @State private var step: ReviewFlowStep = .sentiment
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Animations are enabled only when the app opts in *and* the user hasn't
    /// turned on Reduce Motion in Accessibility settings.
    private var animationsEnabled: Bool {
        manager.config.enableAnimations && !reduceMotion
    }

    var body: some View {
        ZStack {
            // Dim scrim
            Color.black
                .opacity(manager.config.appearance.scrimOpacity)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            // Card
            Group {
                switch step {
                case .sentiment:
                    ReviewPromptCard(onSentiment: handleSentiment)
                        .transition(cardTransition)

                case .rateChoice:
                    RateChoiceCard(
                        onRate: handleRate,
                        onFeedback: { transition(to: .feedback) },
                        onLater: { dismiss() },
                        onNeverAskAgain: { manager.markNeverAskAgain() }
                    )
                    .transition(cardTransition)

                case .feedback:
                    FeedbackCard(
                        onEmail: handleEmail,
                        onFeedbackURL: handleFeedbackURL,
                        onLater: { dismiss() }
                    )
                    .transition(cardTransition)
                }
            }
            .padding(.horizontal, 24)
            .accessibilityAddTraits(.isModal)
        }
        .onAppear {
            manager.markPromptShown()
        }
    }

    // MARK: Transitions

    private var cardTransition: AnyTransition {
        animationsEnabled
            ? .asymmetric(
                insertion: .scale(scale: 0.9).combined(with: .opacity),
                removal: .scale(scale: 0.95).combined(with: .opacity)
              )
            : .identity
    }

    // MARK: Handlers

    private func handleSentiment(_ sentiment: UserSentiment) {
        manager.handleSentiment(sentiment)
        switch sentiment {
        case .positive:
            requestStoreReview()
            dismiss(reason: .reviewRequested)
        case .neutral:
            transition(to: .rateChoice)
        case .negative:
            transition(to: .feedback)
        }
    }

    private func handleRate() {
        requestStoreReview()
        dismiss(reason: .reviewRequested)
    }

    private func handleEmail() {
        guard let email = manager.config.feedbackEmail,
              let url = URL(string: "mailto:\(email)") else { return }
        openURL(url)
        manager.analyticsHandler?(.feedbackOpened)
        dismiss(reason: .feedbackOpened)
    }

    private func handleFeedbackURL() {
        guard let url = manager.config.feedbackURL else { return }
        openURL(url)
        manager.analyticsHandler?(.feedbackOpened)
        dismiss(reason: .feedbackOpened)
    }

    private func dismiss(reason: ReviewFlowDismissReason = .userInitiated) {
        manager.dismissPrompt(reason: reason)
    }

    private func transition(to newStep: ReviewFlowStep) {
        if animationsEnabled {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                step = newStep
            }
        } else {
            step = newStep
        }
    }

    // MARK: Platform helpers

    private func requestStoreReview() {
        manager.analyticsHandler?(.ratingRequested)

        // Prefer the native, in-app rating prompt. Only if that path is
        // unavailable do we fall back to the App Store "write a review" page —
        // otherwise the user would be shown the native prompt *and* be kicked
        // out of the app into Safari at the same time.
        if presentNativeReviewPrompt() { return }

        if let appStoreID = manager.config.appStoreID,
           let url = URL(string: "https://apps.apple.com/app/id\(appStoreID)?action=write-review") {
            openURL(url)
        }
    }

    /// Presents Apple's native in-app rating prompt.
    ///
    /// - Returns: `true` if a native prompt was requested, `false` if no native
    ///   path was available (in which case the caller should fall back).
    private func presentNativeReviewPrompt() -> Bool {
#if os(iOS)
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else { return false }

        if #available(iOS 16.0, *) {
            AppStore.requestReview(in: scene)
        } else {
            SKStoreReviewController.requestReview(in: scene)
        }
        return true
#elseif os(macOS)
        SKStoreReviewController.requestReview()
        return true
#else
        return false
#endif
    }

    private func openURL(_ url: URL) {
#if os(iOS)
        UIApplication.shared.open(url)
#elseif os(macOS)
        NSWorkspace.shared.open(url)
#endif
    }
}

// MARK: - Card style modifier

private struct ReviewCardModifier: ViewModifier {
    let cornerRadius: CGFloat
    let backgroundColor: Color?

    func body(content: Content) -> some View {
        content
            .padding(24)
            .background {
                if let color = backgroundColor {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(color)
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.regularMaterial)
                }
            }
            .shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 8)
    }
}

extension View {
    func reviewCard(cornerRadius: CGFloat, backgroundColor: Color?) -> some View {
        modifier(ReviewCardModifier(cornerRadius: cornerRadius, backgroundColor: backgroundColor))
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    ReviewFlowOverlay()
        .environmentObject({
            let m = ReviewManager()
            m.storage.launchCount = 10
            return m
        }())
}
#endif
#endif

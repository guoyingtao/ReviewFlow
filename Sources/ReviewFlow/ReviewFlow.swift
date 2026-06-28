/// ReviewFlow — Intelligent App Store review prompts for iOS.
///
/// ReviewFlow helps you increase App Store ratings without annoying your users.
/// Instead of immediately asking for a review, it first measures sentiment:
///
/// - **Happy users** → guided to Apple's native rating dialog
/// - **Neutral users** → offered a choice between rating and feedback
/// - **Unhappy users** → directed to email or a feedback URL instead
///
/// ## Quick start
///
/// ```swift
/// import ReviewFlow
///
/// @main
/// struct MyApp: App {
///     @StateObject private var reviewManager = ReviewManager(
///         config: ReviewFlowConfig(
///             minLaunchCount: 3,
///             appStoreID: "123456789",
///             feedbackEmail: "support@example.com"
///         )
///     )
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .reviewFlow(manager: reviewManager)
///                 .onAppear {
///                     reviewManager.recordLaunch()
///                     reviewManager.requestReviewIfNeeded()
///                 }
///         }
///     }
/// }
/// ```
///
/// ## Key types
///
/// | Type | Description |
/// |------|-------------|
/// | ``ReviewManager`` | Central coordinator — record launches, events, and trigger the prompt |
/// | ``ReviewFlowConfig`` | Configure thresholds, destinations, and UX |
/// | ``ReviewFlowTexts`` | Customise or localise all strings |
/// | ``ReviewFlowAppearance`` | Override colours, fonts, and corner radius |
/// | ``ReviewStorage`` | Swap the persistence backend |
/// | ``UserDefaultsReviewStorage`` | Default `UserDefaults`-backed storage |
/// | ``HapticManager`` | Haptic feedback utilities |
@_documentation(visibility: public)
public enum ReviewFlow {

    /// The current ReviewFlow version string.
    public static let version = "1.0.0"
}

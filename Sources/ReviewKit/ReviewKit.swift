/// ReviewKit — Intelligent App Store review prompts for iOS.
///
/// ReviewKit helps you increase App Store ratings without annoying your users.
/// Instead of immediately asking for a review, it first measures sentiment:
///
/// - **Happy users** → guided to Apple's native rating dialog
/// - **Neutral users** → offered a choice between rating and feedback
/// - **Unhappy users** → directed to email or a feedback URL instead
///
/// ## Quick start
///
/// ```swift
/// import ReviewKit
///
/// @main
/// struct MyApp: App {
///     @StateObject private var reviewManager = ReviewManager(
///         config: ReviewKitConfig(
///             minLaunchCount: 3,
///             appStoreID: "123456789",
///             feedbackEmail: "support@example.com"
///         )
///     )
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .reviewKit(manager: reviewManager)
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
/// | ``ReviewKitConfig`` | Configure thresholds, destinations, and UX |
/// | ``ReviewKitTexts`` | Customise or localise all strings |
/// | ``ReviewKitAppearance`` | Override colours, fonts, and corner radius |
/// | ``ReviewStorage`` | Swap the persistence backend |
/// | ``UserDefaultsReviewStorage`` | Default `UserDefaults`-backed storage |
/// | ``HapticManager`` | Haptic feedback utilities |
@_documentation(visibility: public)
public enum ReviewKit {

    /// The current ReviewKit version string.
    public static let version = "1.0.0"
}

# ReviewFlow

[![CI](https://github.com/guoyingtao/ReviewFlow/actions/workflows/ci.yml/badge.svg)](https://github.com/guoyingtao/ReviewFlow/actions/workflows/ci.yml)

**ReviewFlow** is a production-ready, open-source Swift Package that helps iOS developers increase App Store ratings without annoying users.

Instead of immediately asking users to rate your app, ReviewFlow first measures their sentiment. Happy users are guided to Apple's in-app review prompt; unhappy users are offered a way to contact you instead.

---

## Features

- 🎯 **Smart sentiment detection** before showing any rating prompt  
- 🍎 **Native SwiftUI UI** — card overlay with blur background, spring animations, Dark Mode, Dynamic Type, and full Accessibility support  
- ⚙️ **Configurable eligibility rules** — launch count, install days, cooldown, significant events, version deduplication  
- 🔌 **Pluggable storage** — swap `UserDefaults` for Keychain, CloudKit, Core Data, or any other backend  
- 📊 **Analytics hooks** — receive every flow event in a single closure  
- 🔔 **Delegate callbacks** for lifecycle events  
- 🎵 **Haptic feedback** (configurable)  
- 🌐 **Localised out of the box** — 11 languages bundled (EN, 简体中文, 繁體中文, 日本語, 한국어, ES, FR, DE, PT-BR, RU, IT); override any string for the rest  
- 🎨 **Fully customisable** — colours, fonts, corner radius, animations  
- ✅ **No third-party dependencies**  
- 🧪 **Unit tested core logic**  

---

## Requirements

| | Minimum |
|---|---|
| iOS | 15.0 |
| macOS | 12.0 |
| Swift | 5.9 |
| Xcode | 15.0 |

---

## Installation

### Swift Package Manager

Add ReviewFlow to your project via **File › Add Package Dependencies** in Xcode, then enter the repository URL:

```
https://github.com/guoyingtao/ReviewFlow
```

Or add it directly in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/guoyingtao/ReviewFlow", from: "1.0.0"),
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "ReviewFlow", package: "ReviewFlow")
        ]
    ),
]
```

---

## Quick Start

```swift
import SwiftUI
import ReviewFlow

@main
struct MyApp: App {

    @StateObject private var reviewManager = ReviewManager(
        config: ReviewFlowConfig(
            minLaunchCount: 3,
            appStoreID: "123456789",
            feedbackEmail: "support@example.com"
        )
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Attach the overlay to your root view
                .reviewFlow(manager: reviewManager)
                .onAppear {
                    reviewManager.recordLaunch()
                    reviewManager.requestReviewIfNeeded()
                }
        }
    }
}
```

That's it! ReviewFlow handles the rest.

---

## User Flow

```
requestReviewIfNeeded()
        │
        ▼
 Eligibility check
        │
   ┌────┴────┐
   │         │
Not eligible  Eligible
   │         │
  done   Show ReviewPromptView
             │
     ┌───────┼────────┐
     │       │        │
  😊 Love  😐 OK    😞 Needs
     │       │        │
     ▼       ▼        ▼
  Native  Rate/     Feedback
  review  Feedback  only (no
  dialog  choice    rating ask)
```

---

## Configuration

Pass a `ReviewFlowConfig` to `ReviewManager` to customise all eligibility thresholds and behaviour.

```swift
let config = ReviewFlowConfig(
    // Eligibility thresholds
    minLaunchCount: 5,            // Default: 5
    minDaysSinceInstall: 3,       // Default: 3
    cooldownDays: 7,              // Default: 7
    minimumSignificantEvents: 2,  // Default: 0 (disabled)

    // Feedback destinations
    feedbackEmail: "support@example.com",
    feedbackURL: URL(string: "https://example.com/feedback"),

    // App Store
    appStoreID: "123456789",

    // Experience
    enableAnimations: true,           // Default: true
    enableHaptics: true,              // Default: true
    showNeverAskAgainOption: true,    // Default: true

    // Customisation
    texts: .default,
    appearance: .default
)
```

### Default Eligibility Rules

| Rule | Default | Description |
|------|---------|-------------|
| `minLaunchCount` | 5 | Minimum app launches before prompting |
| `minDaysSinceInstall` | 3 | Minimum days since first launch |
| `cooldownDays` | 7 | Days between successive prompts |
| `minimumSignificantEvents` | 0 | Minimum named events (0 = disabled) |
| Version deduplication | always | Never prompt twice for the same version |
| Never Ask Again | always | Respected once the user opts out via the "Don't Ask Again" button (shown on the neutral choice card when `showNeverAskAgainOption` is `true`) |

---

## Recording Significant Events

Use `recordEvent(_:)` to track meaningful user actions. Combine with `minimumSignificantEvents` to ensure users have actually engaged with your app before you ask for a review.

```swift
// After the user completes a meaningful action
reviewManager.recordEvent("ExportCompleted")
reviewManager.recordEvent("ProjectShared")
reviewManager.recordEvent("PurchaseFinished")

// Later, when appropriate
reviewManager.requestReviewIfNeeded()
```

---

## Customisation

### Texts & Localisation

ReviewFlow ships a String Catalog with **11 built-in languages** — English, Simplified & Traditional Chinese, Japanese, Korean, Spanish, French, German, Brazilian Portuguese, Russian, and Italian. `ReviewFlowTexts.default` automatically resolves to the user's current language, and any unsupported language falls back to English. No setup required.

To customise copy or add a language we don't ship yet, start from `.default` and override only what you need:

```swift
var texts = ReviewFlowTexts.default
texts.promptTitle = "Enjoying the app?"
texts.promptQuestion = "We'd love to hear from you."
texts.loveItButton = "❤️  Love it!"
texts.itsOKButton = "🤔  It's alright"
texts.needsImprovementButton = "😞  Needs work"
texts.maybeLaterButton = "Not now"

let config = ReviewFlowConfig(texts: texts)
```

### Appearance

```swift
var appearance = ReviewFlowAppearance.default
appearance.cornerRadius = 28
appearance.accentColor = .purple
appearance.titleFont = .title3.bold()
appearance.bodyFont = .callout
appearance.scrimOpacity = 0.5

let config = ReviewFlowConfig(appearance: appearance)
```

---

## Analytics Integration

Set `analyticsHandler` to receive every event:

```swift
reviewManager.analyticsHandler = { event in
    // Forward to your analytics provider
    MyAnalytics.track(event.name, properties: event.properties)
}
```

Available events:

| Event | Description |
|-------|-------------|
| `.promptShown` | The prompt became visible |
| `.sentimentSelected(UserSentiment)` | The user tapped a sentiment button |
| `.ratingRequested` | The system rating dialog was triggered |
| `.feedbackOpened` | The user opened email or a feedback URL |
| `.dismissed(reason:)` | The prompt closed. `reason` distinguishes completion (`.reviewRequested`, `.feedbackOpened`) from abandonment (`.userInitiated`) or opt-out (`.neverAskAgain`) |
| `.eligibilityCheckFailed(reason:)` | Eligibility check didn't pass |

### Examples

```swift
// Mixpanel
reviewManager.analyticsHandler = { event in
    Mixpanel.mainInstance().track(event: event.name, properties: event.properties)
}

// Firebase
reviewManager.analyticsHandler = { event in
    Analytics.logEvent(event.name, parameters: event.properties)
}
```

---

## Delegate Callbacks

```swift
class MyViewController: ReviewManagerDelegate {

    func viewDidLoad() {
        reviewManager.delegate = self
    }

    func reviewManagerDidShowPrompt(_ manager: ReviewManager) {
        print("Prompt shown")
    }

    func reviewManagerDidDismissPrompt(_ manager: ReviewManager) {
        print("Prompt dismissed")
    }

    func reviewManager(_ manager: ReviewManager, didReceiveSentiment sentiment: UserSentiment) {
        print("User sentiment:", sentiment)
    }

    func reviewManager(_ manager: ReviewManager, didRecordLaunch count: Int) {
        print("Launch #\(count)")
    }
}
```

All delegate methods have empty default implementations — implement only what you need.

---

## Custom Storage Backend

Implement `ReviewStorage` to replace the default `UserDefaults` backend:

```swift
import ReviewFlow

final class KeychainReviewStorage: ReviewStorage {
    var launchCount: Int {
        get { Keychain.integer(forKey: "rkLaunchCount") ?? 0 }
        set { Keychain.set(newValue, forKey: "rkLaunchCount") }
    }
    var firstLaunchDate: Date? {
        get { Keychain.date(forKey: "rkFirstLaunch") }
        set { Keychain.set(newValue, forKey: "rkFirstLaunch") }
    }
    // ... implement the remaining properties
}

let manager = ReviewManager(
    config: .default,
    storage: KeychainReviewStorage()
)
```

For App Group support using the built-in storage:

```swift
let storage = UserDefaultsReviewStorage(suiteName: "group.com.example.app")
let manager = ReviewManager(config: .default, storage: storage)
```

---

## Swift Concurrency

ReviewFlow is `@MainActor`-safe. Use the async variant when calling from a Swift Concurrency context:

```swift
.task {
    await performSetup()
    reviewManager.recordEvent("SetupCompleted")
    await reviewManager.requestReviewIfNeededAsync()
}
```

---

## Shared Instance

For simple integrations, use the pre-configured singleton:

```swift
// In your App / AppDelegate
ReviewManager.shared.recordLaunch()

// After a significant action
ReviewManager.shared.recordEvent("ProjectExported")
ReviewManager.shared.requestReviewIfNeeded()

// Attach the overlay
ContentView()
    .reviewFlow()  // Uses ReviewManager.shared
```

---

## Debugging & Testing

Reset all state during development:

```swift
reviewManager.reset()
```

Use the public `InMemoryReviewStorage` in tests or SwiftUI previews to keep state fast and isolated (nothing is written to `UserDefaults`):

```swift
let storage = InMemoryReviewStorage(
    launchCount: 10,
    firstLaunchDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())
)

let manager = ReviewManager(config: .default, storage: storage)
manager.requestReviewIfNeeded()
```

---

## FAQ

**Q: Will this bypass Apple's rate-limiting on review prompts?**  
A: No. ReviewFlow calls the standard `SKStoreReviewController.requestReview(in:)` API, which Apple limits to three prompts per 365 days. ReviewFlow's own cooldown adds an extra layer of protection.

**Q: Can I show the prompt manually regardless of eligibility?**  
A: Seed the storage with eligible values, then call `requestReviewIfNeeded()`. For example, inject an `InMemoryReviewStorage` (or your own backend) with a high `launchCount` and an old `firstLaunchDate` so every eligibility rule passes.

**Q: Does ReviewFlow track users or collect data?**  
A: No. ReviewFlow stores only launch counts, dates, and event counts in `UserDefaults` (or your custom backend) on the device. No data leaves the device.

**Q: Can I use ReviewFlow with UIKit?**  
A: The core logic (`ReviewManager`, `ReviewStorage`, config) works anywhere. The SwiftUI UI is SwiftUI-only. You can trigger the native `SKStoreReviewController` directly from UIKit using `ReviewManager` as the state tracker.

**Q: What happens if the user taps "Needs improvement"?**  
A: ReviewFlow shows a feedback card (email / URL). It never calls `SKStoreReviewController` for unhappy users, and it does NOT set "never ask again" — they may feel better in a future session.

---

## Best Practices

- Call `recordLaunch()` **once per cold start**, not on every scene activation.  
- Call `requestReviewIfNeeded()` after a naturally positive moment (successful export, level completed, project saved), not immediately on launch.  
- Keep `minLaunchCount` ≥ 3 and `minDaysSinceInstall` ≥ 1 to avoid prompting brand-new users.  
- Set `feedbackEmail` or `feedbackURL` so unhappy users have a place to go.  
- Use `recordEvent(_:)` + `minimumSignificantEvents` for deeper engagement gating.  

---

## License

ReviewFlow is released under the [MIT License](LICENSE).

---

## Contributing

Contributions, bug reports, and feature requests are welcome. Please open an issue or a pull request.

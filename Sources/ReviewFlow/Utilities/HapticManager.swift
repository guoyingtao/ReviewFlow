import Foundation
#if os(iOS)
import UIKit
#endif

// MARK: - HapticManager

/// Lightweight wrapper around UIKit haptic feedback generators.
///
/// ReviewFlow calls these automatically when ``ReviewFlowConfig/enableHaptics``
/// is `true`.  You can also use them directly in your own app.
public enum HapticManager {

    /// Triggers a selection-change haptic (subtle tick).
    public static func selection() {
#if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
#endif
    }

    /// Triggers an impact haptic with the given intensity style.
    ///
    /// - Parameter style: The impact intensity. Defaults to `.medium`.
    public static func impact(_ style: UIImpactFeedbackStyle = .medium) {
#if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
#endif
    }

    /// Triggers a notification haptic (success, warning, or error).
    ///
    /// - Parameter type: The notification type.
    public static func notification(_ type: UINotificationFeedbackType) {
#if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
#endif
    }
}

// MARK: - Type aliases for cross-platform compilation

#if os(iOS)
/// Cross-platform alias for the impact feedback style.
public typealias UIImpactFeedbackStyle = UIImpactFeedbackGenerator.FeedbackStyle

/// Cross-platform alias for the notification feedback type.
public typealias UINotificationFeedbackType = UINotificationFeedbackGenerator.FeedbackType
#else
/// Placeholder type used on non-iOS platforms where haptic feedback is unavailable.
public enum UIImpactFeedbackStyle {
    case light, medium, heavy, soft, rigid
}

/// Placeholder type used on non-iOS platforms where haptic feedback is unavailable.
public enum UINotificationFeedbackType {
    case success, warning, error
}
#endif

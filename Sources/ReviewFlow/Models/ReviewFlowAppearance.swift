#if canImport(SwiftUI)
import SwiftUI

// MARK: - ReviewFlowAppearance

/// Visual appearance settings for ReviewFlow's UI components.
///
/// Customise colours, fonts, corner radii, and more to match your app's
/// design language.
///
/// ```swift
/// var appearance = ReviewFlowAppearance.default
/// appearance.accentColor = .purple
/// appearance.cornerRadius = 24
/// let config = ReviewFlowConfig(appearance: appearance)
/// ```
public struct ReviewFlowAppearance: Sendable {

    // MARK: Shape

    /// Corner radius applied to the prompt card. Default: **20**.
    public var cornerRadius: CGFloat

    // MARK: Typography

    /// Font used for the card title. Default: `.headline`.
    public var titleFont: Font

    /// Font used for body / subtitle text. Default: `.subheadline`.
    public var bodyFont: Font

    /// Font used for action buttons. Default: `.body`.
    public var buttonFont: Font

    // MARK: Colour

    /// Accent colour applied to primary action buttons and highlights.
    /// Default: `.accentColor` (follows the app's global tint).
    public var accentColor: Color

    /// Background colour of the prompt card.
    /// Pass `nil` to use the adaptive `.regularMaterial` blur background.
    /// Default: `nil`.
    public var cardBackgroundColor: Color?

    /// Opacity of the dim scrim behind the card. Default: **0.4**.
    public var scrimOpacity: Double

    // MARK: Default

    /// Default appearance matching Apple's Human Interface Guidelines.
    public static let `default` = ReviewFlowAppearance()

    // MARK: Init

    public init(
        cornerRadius: CGFloat = 20,
        titleFont: Font = .headline,
        bodyFont: Font = .subheadline,
        buttonFont: Font = .body,
        accentColor: Color = .accentColor,
        cardBackgroundColor: Color? = nil,
        scrimOpacity: Double = 0.4
    ) {
        self.cornerRadius = cornerRadius
        self.titleFont = titleFont
        self.bodyFont = bodyFont
        self.buttonFont = buttonFont
        self.accentColor = accentColor
        self.cardBackgroundColor = cardBackgroundColor
        self.scrimOpacity = scrimOpacity
    }
}
#endif

//
//  Style.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(watchOS)
    import WatchKit
#elseif os(OSX)
    import AppKit
#endif

public struct Style: StyleType {
    public let font: Font
    public let kerning: CGFloat
    public let lineSpacing: CGFloat
    public let textColor: ColorSet?
    
    /**
     Primary initializer to use when creating a Style
     
     - parameter font:            The `Font` to use for this style
     - parameter kerning:         Any kerning that should be applied. A value of 0 disables kerning
     - parameter lineSpacing:     Any line spacing that should be applied. A value of 0 disables line spacing. Values < 0 are invalid and will be clamped to 0.
     - parameter textColor:       The `ColorSet` to use for the text color
     
     - returns: A valid `Style`
     */
    public init(font: Font, kerning: CGFloat = 0, lineSpacing: CGFloat = 0, textColor: ColorSet? = nil) {
        self.font = font
        self.kerning = kerning
        // Make sure that the value is >= 0, don't save negitive values
        self.lineSpacing = lineSpacing >= 0 ? lineSpacing : 0
        self.textColor = textColor
    }
    
    /**
     Convenience initializer for creating a `Style` that duplicates an existing `Style` just changing it's `textColor`
     
     - parameter style:     The original `Style` to duplicate
     - parameter textColor: The new `ColorSet` to use for the `textColor`
     
     - returns: A new `Style`
     */
    public init(style: Style, textColor: ColorSet?) {
        self.init(font: style.font, kerning: style.kerning, lineSpacing: style.lineSpacing, textColor: textColor)
    }
}

//
//  Style.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

/**
 *  A combination of font, kerning, linespacing, and text color. The most common things needed to style text in one nice package.
 */
public struct Style {
    /// The `Font` to use for this style
    public let font: Font
    /// Any kerning that should be applied. A value of 0 disables kerning
    public let kerning: CGFloat
    /// Any line spacing that should be applied. A value of 0 disables line spacing. Values must be >= 0.
    public let lineSpacing: CGFloat
    /// The `ColorSet` to use for the text color
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
    
    /**
     Creates a dictionary of text attributes. Commenly used to create an `NSAttributedString` or used in `UIAppearance` methods. If `textColor` is not nil then `textColor.normalColor` will be used for the text. If `backgroundColor` is not nil and `showBackgroundColor` is `true` then `backgroundColor.normalColor` will be used for the background.
     
     - parameter alignment:           The text alignment to use. (Defaults to Left)
     - parameter lineBreakMode:       The line break mode to use. (Defaults to Word Wrapping)
     
     - returns: A dictionary of attributes
     */
    public func textAttributes(alignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> [String : AnyObject] {
        var attributes = [String : AnyObject]()
        
        attributes[NSFontAttributeName] = font.font
        
        if let textColor = textColor {
            attributes[NSForegroundColorAttributeName] = textColor.normalColor.color
        }
        
        if kerning != 0 {
            attributes[NSKernAttributeName] = kerning
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment
        
        if lineSpacing != 0 {
            paragraphStyle.lineSpacing = lineSpacing
        }
        
        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        
        return attributes
    }
}

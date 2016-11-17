//
//  StyleType.swift
//  Flair
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(watchOS)
    import WatchKit
#elseif os(OSX)
    import AppKit
#endif

/**
 *  A combination of font, kerning, linespacing, and text color. The most common things needed to style text in one nice package.
 */
public protocol StyleType: Equatable {
    associatedtype AssociatedColorSet: ColorSetType
    
    /// The `Font` to use for this style
    var font: Font { get }
    /// Any kerning that should be applied. A value of 0 disables kerning
    var kerning: CGFloat { get }
    /// Any line hight scaling that should be applied. A value of 0 disables line high adjustment. Values must be >= 0.
    var lineHeightMultiple: CGFloat { get }
    /// The `ColorSet` to use for the text color
    var textColor: AssociatedColorSet? { get }
    /// The style only has `font` & maybe `textColor`. No `kerning` or `lineSpacing`
    var isBasicStyle: Bool { get }
}

public extension StyleType {
    public var isBasicStyle: Bool { return kerning == 0 && lineHeightMultiple == 0 }
    
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
            attributes[NSKernAttributeName] = kerning as NSNumber
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment
        
        if lineHeightMultiple != 0 {
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
        }
        
        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        
        return attributes
    }
}

public func ==<T: StyleType>(lhs: T, rhs: T) -> Bool {
    return lhs.font == rhs.font && lhs.textColor == rhs.textColor && lhs.kerning == rhs.kerning && lhs.lineHeightMultiple == rhs.lineHeightMultiple
}

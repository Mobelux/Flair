//
//  StyleType.swift
//  Flair
//
//  MIT License
//
//  Copyright (c) 2017 Mobelux
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#if os(iOS) || os(tvOS)
    import UIKit
	public typealias LineBreak = NSLineBreakMode
#elseif os(watchOS)
    import WatchKit
	public typealias LineBreak = NSLineBreakMode
#elseif os(OSX)
    import AppKit
	public typealias LineBreak = NSParagraphStyle.LineBreakMode
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
	public func textAttributes(alignment: NSTextAlignment = .left, lineBreakMode: LineBreak = .byWordWrapping) -> [NSAttributedStringKey : Any] {
        var attributes = [NSAttributedStringKey : Any]()
        
        attributes[NSAttributedStringKey.font] = font.font
        
        if let textColor = textColor {
            attributes[NSAttributedStringKey.foregroundColor] = textColor.normalColor.color
        }
        
        if kerning != 0 {
            attributes[NSAttributedStringKey.kern] = kerning as NSNumber
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment

        if lineHeightMultiple != 0, let platformFont = font.font {
            let pointSize = platformFont.pointSize
            // The height of the line in points. It should never be less then the point size of the font or clipping would occur
            let lineHeight = max(lineHeightMultiple * pointSize, pointSize)
            // Line spacing is EXTRA spacing that is desired beyond what it required to fit the font. We devide by 2 so we have only 1/2 above, and 1/2 below
            paragraphStyle.lineSpacing = (lineHeight - pointSize) / 2
        }

        attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        
        return attributes
    }
}

public func ==<T: StyleType>(lhs: T, rhs: T) -> Bool {
    return lhs.font == rhs.font && lhs.textColor == rhs.textColor && lhs.kerning == rhs.kerning && lhs.lineHeightMultiple == rhs.lineHeightMultiple
}

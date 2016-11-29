//
//  String+Style.swift
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

public extension String {
    
    /**
     Creates an `NSAttributedString`. This is a convenience method to calling `textAttributes(alignment:, lineBreakMode:, showBackgroundColor:)` on a `Style`, and then creating an attributed string using those attributes. If `textColor` is not nil then `textColor.normalColor` will be used for the text.
     
     - parameter style:               The `Style` to use for the core attributes
     - parameter alignment:           The text alignment to use. (Defaults to Left)
     - parameter lineBreakMode:       The line break mode to use. (Defaults to Word Wrapping)
     - parameter multiline:           Will this string use multiple lines. If not then the line height won't be changed
     
     - returns: A dictionary of attributes
     */
    public func attributedString(for style: Style, alignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byWordWrapping, multiline: Bool = true) -> NSAttributedString {
        let attributes = style.textAttributes(alignment: alignment, lineBreakMode: lineBreakMode, multiline: multiline)

        return NSAttributedString(string: self, attributes: attributes)
    }
}

//
//  String+Style.swift
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
     
     - returns: A dictionary of attributes
     */
    public func attributedString(for style: Style, alignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> NSAttributedString {
        let attributes = style.textAttributes(alignment: alignment, lineBreakMode: lineBreakMode)

        return NSAttributedString(string: self, attributes: attributes)
    }
}

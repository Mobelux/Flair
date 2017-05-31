//
//  Style.swift
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

public struct Style: StyleType {
    public let font: Font
    public let kerning: CGFloat
    public let lineHeightMultiple: CGFloat
    public let textColor: ColorSet?
    
    /**
     Primary initializer to use when creating a Style
     
     - parameter font:            The `Font` to use for this style
     - parameter kerning:         Any kerning that should be applied. A value of 0 disables kerning
     - parameter lineHeightMultiple:     Any line high scaling that should be applied. A value of 0 disables line high adjustment. Values < 0 are invalid and will be clamped to 0.
     - parameter textColor:       The `ColorSet` to use for the text color
     
     - returns: A valid `Style`
     */
    public init(font: Font, kerning: CGFloat = 0, lineHeightMultiple: CGFloat = 0, textColor: ColorSet? = nil) {
        self.font = font
        self.kerning = kerning
        // Make sure that the value is >= 0, don't save negitive values
        self.lineHeightMultiple = lineHeightMultiple >= 0 ? lineHeightMultiple : 0
        self.textColor = textColor
    }
    
    /**
     Convenience initializer for creating a `Style` that duplicates an existing `Style` just changing it's `textColor`
     
     - parameter style:     The original `Style` to duplicate
     - parameter textColor: The new `ColorSet` to use for the `textColor`
     
     - returns: A new `Style`
     */
    public init(style: Style, textColor: ColorSet?) {
        self.init(font: style.font, kerning: style.kerning, lineHeightMultiple: style.lineHeightMultiple, textColor: textColor)
    }
}

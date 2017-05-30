//
//  PlatformColor+Components.swift
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
//  THE SOFTWARE.//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(watchOS)
    import WatchKit
#elseif os(OSX)
    import AppKit
#endif

public extension PlatformColor {
    /// Is this color opaque? true if alpha == 1
    public var opaque: Bool {
        guard let color = getColor() else { return false }
        let opaque = color.alpha == 1
        return opaque
    }
    
    /**
     Get the red, green, blue, and alpha components of this color
     
     - returns: The Color components in UIColor/NSColor space (0 to 1.0), or nil if the current color isn't a simple color that can be converted to Color components (colors from a pattern image are a good example of colors that will return nil).
     */
    public func getColor() -> Color? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        #if os(OSX)
            /*  This is far from ideal, however OS X's getRed function doesn't return a bool to indicate success like iOS.
                Even worse is that it will throw an exception if it can't get the RGBA components, but the method isn't
                marked as throws so in Swift we can't do a try/catch to prevent a crash. So for now we are just checking for the most
                common case that would cause a crash: if the color is from a pattern image.
            */
            if colorSpaceName == NSPatternColorSpace {
                return nil
            } else {
                getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                return Color(red: red, green: green, blue: blue, alpha: alpha)
            }
        #else
            if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                return Color(red: red, green: green, blue: blue, alpha: alpha)
            } else {
                return nil
            }
        #endif
        
    }
}

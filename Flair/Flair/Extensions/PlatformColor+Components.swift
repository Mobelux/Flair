//
//  PlatformColor+Components.swift
//  Flair
//
//  Created by Jerry Mayers on 7/20/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

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

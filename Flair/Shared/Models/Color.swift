//
//  Color.swift
//  Flair
//
//  Created by Jerry Mayers on 7/20/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS)
    import UIKit
    public typealias PlatformColor = UIColor
#elseif os(watchOS)
    import WatchKit
    public typealias PlatformColor = UIColor
#elseif os(OSX)
    import AppKit
    public typealias PlatformColor = NSColor
#endif

public protocol ColorType {
    var red: CGFloat { get }
    var green: CGFloat { get }
    var blue: CGFloat { get }
    var alpha: CGFloat { get }
    var color: PlatformColor { get }

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    init?(color: PlatformColor?)
}

/**
 Are two Colors approximately the same. Compares 2 Colors with around 255 steps of accuracy for each channel.
 */
public func ~=(lhs: ColorType, rhs: ColorType) -> Bool {
    // If colors have been converted from UInt8 then we only have 1/255 = 0.0039 for the precision, so realistically we need to compare at most 2 decimals to be approximately equal
    let numberOfDecimals = 2

    let lhsRed = lhs.red.roundTo(numberOfDecimalPlaces: numberOfDecimals)
    let lhsGreen = lhs.green.roundTo(numberOfDecimalPlaces: numberOfDecimals)
    let lhsBlue = lhs.blue.roundTo(numberOfDecimalPlaces: numberOfDecimals)
    let lhsAlpha = lhs.alpha.roundTo(numberOfDecimalPlaces: numberOfDecimals)

    let rhsRed = rhs.red.roundTo(numberOfDecimalPlaces: numberOfDecimals)
    let rhsGreen = rhs.green.roundTo(numberOfDecimalPlaces: numberOfDecimals)
    let rhsBlue = rhs.blue.roundTo(numberOfDecimalPlaces: numberOfDecimals)
    let rhsAlpha = rhs.alpha.roundTo(numberOfDecimalPlaces: numberOfDecimals)

    return lhsRed == rhsRed && lhsGreen == rhsGreen && lhsBlue == rhsBlue && lhsAlpha == rhsAlpha
}

/// Platform agnostic color representation
public struct Color: ColorType, Equatable {
    /// Red component in the range 0 to 1
    public let red: CGFloat
    /// Green component in the range 0 to 1
    public let green: CGFloat
    /// Blue component in the range 0 to 1
    public let blue: CGFloat
    /// Alpha component in the range 0 to 1
    public let alpha: CGFloat
    
    /// This Color object converted to the current platform's color class. UIColor or NSColor
    public var color: PlatformColor {
        return PlatformColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// luminance is a 0 to 1 value, with 0 being dark (black leaning) and 1 being very bright (white leaning). It is based around the fact that the human eye is more sensitive to green.
    public var luminance: CGFloat {
        return red * 0.21 + green * 0.72 + blue * 0.07
    }
    
    /**
     Initialize a Color with color components. Components should be in the range 0 to 1 for sRGB, or they can extend outside it if P3
     
     - parameter red:   The red component in the range 0 to 1
     - parameter green: The green component in the range 0 to 1
     - parameter blue:  The blue component in the range 0 to 1
     - parameter alpha: The alpha component in the range 0 to 1
     
     - returns: A color
     */
    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    /**
     Initialize a Color with a PlatformColor
     
     - parameter color: The UIColor or NSColor (depending on the platform)
     
     - returns: A Color if the passed in `color` is convertable to a basic RGBA color.
     */
    public init?(color: PlatformColor?) {
        guard let actualColor = color?.getColor() else { return nil }
        self.init(red: actualColor.red, green: actualColor.green, blue: actualColor.blue, alpha: actualColor.alpha)
    }
}

// MARK: - Equatable

public func ==(lhs: Color, rhs: Color) -> Bool {
    return lhs ~= rhs
}

public func ==(pixel: Color, color: PlatformColor) -> Bool {
    guard let rhsColor = Color(color: color) else { return false }
    return pixel == rhsColor
}

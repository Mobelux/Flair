//
//  Sequence+Color.swift
//  Flair
//
//  Created by Jerry Mayers on 3/9/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(watchOS)
    import WatchKit
#elseif os(OSX)
    import AppKit
#endif

public extension Array where Element: ColorType {
    /// Get the color of a single pixel, in the sRGB color space (for now). Useful if you want to cache an array of Colors since geting the pixel colors from an image is expensive
    ///
    /// - Parameters:
    ///   - x: The x cordinate of the pixel in points
    ///   - y: The y cordinate of the pixel in points
    ///   - imageSize: The size of the image these pixels came from, in points
    ///   - imageScale: The scale (1x, 2x, 3x) for the image these pixels came from
    /// - Returns: The color for that pixel if the coordinates are in bounds
    public func pixelAt(x: Int, y: Int, imageSize: CGSize, imageScale: CGFloat) -> ColorType? {
        let colorsPerRow = Int(imageSize.width * imageScale)
        let yInPixels = y * Int(imageScale)
        let xInPixels = x * Int(imageScale)
        let index = yInPixels * colorsPerRow + xInPixels

        guard index < count else { return nil }
        return self[index]
    }
}

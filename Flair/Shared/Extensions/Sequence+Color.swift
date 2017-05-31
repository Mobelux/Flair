//
//  Sequence+Color.swift
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

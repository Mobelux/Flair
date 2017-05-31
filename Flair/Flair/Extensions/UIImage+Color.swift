//
//  UIImage+Color.swift
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

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(watchOS)
    import WatchKit
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
    public enum ImageError: Error {
        case nilCGImage
        case invalidColorSpace
        case couldNotCreateImageContext
    }
    
    public extension UIImage {
        /// Creates an image that is filled with a color.
        
        /**
            Creates an image that is filled with a single Color
         
            - parameter color:  The Color to use as the fill color for the image
            - parameter size:   The size to make the image
         
            - returns:          An image filled with a color
        */
        public static func image(of color: Color, size: CGSize) -> UIImage {
            return image(of: color.color, size: size)
        }
        
        /**
         Creates an image that is filled with a single Color
         
         - parameter color:  The UIColor to use as the fill color for the image
         - parameter size:   The size to make the image
         
         - returns:          An image filled with a color
         */
        public static func image(of color: UIColor, size: CGSize) -> UIImage {
            let image: UIImage

            if #available(iOS 10.0, *) {
                let renderer = UIGraphicsImageRenderer(size: size)
                image = renderer.image(actions: { (context) in
                    color.setFill()
                    context.fill(renderer.format.bounds)
                })
            } else {
                UIGraphicsBeginImageContext(size)
                let context = UIGraphicsGetCurrentContext()
                color.setFill()
                context?.fill(CGRect(origin: .zero, size: size))
                image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
                UIGraphicsEndImageContext()
            }

            return image
        }
        
        /**
            Gets all of the pixels that make up this image. Note that the `Colors` will be in sRGB color space for now.
         
            - returns: An array of `Colors`. These colors are organized left to right, per row, then top top bottom, like if they were characters in a book page.
         */
        public func pixels() throws -> [Color] {
            // Ideally this should take a `UIDisplayGamuet` param and create the correct color space based on that, however I have been unable to properly extract colors in the P3 gamuet outside sRGB...
            
            guard let imageRef = cgImage else { throw ImageError.nilCGImage }
            guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { throw ImageError.invalidColorSpace }
            
            let imageSize = CGSize(width: imageRef.width, height: imageRef.height)
            let numberOfPixels = Int(imageSize.width * imageSize.height)
            
            let bitsPerComponent = 8
            let bytesPerPixel = 4
            let bytesPerRow = bytesPerPixel * Int(imageSize.width)
            
            var rawData = [UInt8].init(repeating: 0, count: bytesPerPixel * numberOfPixels)
            let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            
            guard let context = CGContext(data: &rawData, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: info.rawValue) else { throw ImageError.couldNotCreateImageContext }
            
            context.draw(imageRef, in: CGRect(origin: .zero, size: imageSize))
            
            // Now your rawData contains the image data in the RGBA8888 pixel format, such that each val is 0 to 255. We want 0 to 1.0 since that's what UIColor and the like uses.
            let rawDataTransformed = rawData.map({ CGFloat($0) / 255.0 })
            
            var pixels = [Color]()
            pixels.reserveCapacity(numberOfPixels)
            
            var pixelComponentBuffer = [CGFloat]()
            pixelComponentBuffer.reserveCapacity(4)
            
            for pixelComponent in rawDataTransformed {
                pixelComponentBuffer.append(pixelComponent)
                
                if pixelComponentBuffer.count == bytesPerPixel {
                    pixels.append(Color(red: pixelComponentBuffer[0], green: pixelComponentBuffer[1], blue: pixelComponentBuffer[2], alpha: pixelComponentBuffer[3]))
                    pixelComponentBuffer.removeAll(keepingCapacity: true)
                }
            }
            
            return pixels
        }

        /// Get the color of a single pixel, in the sRGB color space (for now)
        ///
        /// - Parameters:
        ///   - x: The x cordinate of the pixel in points
        ///   - y: The y cordinate of the pixel in points
        /// - Returns: The color for that pixel if the coordinates are in bounds
        /// - Throws: ImageError
        public func pixelAt(x: Int, y: Int) throws -> ColorType? {
            let colors = try pixels()
            return colors.pixelAt(x: x, y: y, imageSize: size, imageScale: scale)
        }
    }
#endif

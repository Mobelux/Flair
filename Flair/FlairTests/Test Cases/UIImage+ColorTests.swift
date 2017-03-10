//
//  UIImage+ColorTests.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair

#if os(iOS) || os(tvOS) || os(watchOS)
    class UIImage_ColorTests: XCTestCase {
        
        func testPixels() {
            let originalColor = Color(red: 1, green: 0.5, blue: 0.25, alpha: 1)
            
            let image = UIImage.image(of: originalColor, size: CGSize(width: 2, height: 2))
            
            do {
                let pixels = try image.pixels()
                let expectedNumberOfPixels = Int(image.size.width * image.size.height * image.scale * image.scale)
                XCTAssert(pixels.count == expectedNumberOfPixels, "Incorrect number of pixels")
                
                for pixel in pixels {
                    XCTAssert(pixel ~= originalColor, "Not correct color :(")
                }
            } catch {
                XCTAssert(false, "Failed to get pixels")
            }
        }

        func testPixelAt() {
            let firstColor = Color(red: 1, green: 0, blue: 0, alpha: 1)
            let secondColor = Color(red: 0, green: 1, blue: 0, alpha: 1)

            let width: CGFloat = 10
            let height: CGFloat = 10
            let scale: CGFloat = 2

            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), true, scale)
            let context = UIGraphicsGetCurrentContext()

            firstColor.color.setFill()
            context?.addRect(CGRect(x: 0, y: 0, width: width / 2, height: height))
            context?.fillPath()
            secondColor.color.setFill()
            context?.addRect(CGRect(x: width/2, y: 0, width: width / 2, height: height))
            context?.fillPath()

            guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
                XCTAssert(false, "Couldn't create the image")
                return
            }
            UIGraphicsEndImageContext()



            let foundFirst = try! image.pixelAt(x: Int(width / 2 - 1), y: 0)
            let foundSecond = try! image.pixelAt(x: Int(width - 1), y: 0)
            XCTAssertNotNil(foundFirst, "Couldn't find the color")
            XCTAssertNotNil(foundSecond, "Couldn't find the color")
            if let foundFirst = foundFirst {
                XCTAssert(foundFirst ~= firstColor, "First color dosn't match")
            }
            if let foundSecond = foundSecond {
                XCTAssert(foundSecond ~= secondColor, "Second color doesn't match")
            }
        }
    }
#endif

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
        
    }
#endif

//
//  ColorTests.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair

class ColorTests: XCTestCase {
    
    func testColorInit() {
        let color = Color(color: PlatformColor.red())
        XCTAssertNotNil(color, "Didn't create a color")
        XCTAssert(color!.red == 1, "Not red")
        XCTAssert(color!.green == 0, "Not red")
        XCTAssert(color!.blue == 0, "Not red")
        XCTAssert(color!.alpha == 1, "Not opaque")
        
        let rgbaColor = Color(red: 0, green: 0, blue: 255, alpha: 1)
        XCTAssert(rgbaColor.red == 0, "Not blue")
        XCTAssert(rgbaColor.green == 0, "Not blue")
        XCTAssert(rgbaColor.blue == 255, "Not blue")
        XCTAssert(rgbaColor.alpha == 1, "Not opaque")
    }
    
    func testLuminance() {
        let color = Color(red: 1, green: 0, blue: 0, alpha: 1)
        let expectedLuminance: CGFloat = 0.21
        XCTAssertEqualWithAccuracy(color.luminance, expectedLuminance, accuracy: 0.001, "Luminance is wrong")
    }
}

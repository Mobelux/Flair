//
//  ColorTests.swift
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

import XCTest
import Flair

class ColorTests: XCTestCase {
    
    func testColorInit() {
        let color = Color(color: PlatformColor.red)
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

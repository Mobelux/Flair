//
//  ColorSetTests.swift
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

class ColorSetTests: XCTestCase {
    
    func testColorSetBasicInit() {
        let color = Color(color: PlatformColor.red)
        XCTAssertNotNil(color!, "Didn't create a color")
        let colorSet = ColorSet(normalColor: color!)
        
        XCTAssert(color == colorSet.normalColor, "Colors don't match")
        XCTAssertNil(colorSet.highlightedColor, "Should be nil")
        XCTAssertNil(colorSet.selectedColor, "Should be nil")
        XCTAssertNil(colorSet.disabledColor, "Should be nil")
    }
    
    func tetColorSetFullInit() {
        let normalColor = Color(color: PlatformColor.red)
        XCTAssertNotNil(normalColor, "Didn't create a color")
        let highlightedColor = Color(color: PlatformColor.green)
        XCTAssertNotNil(highlightedColor, "Didn't create a color")
        let selectedColor = Color(color: PlatformColor.orange)
        XCTAssertNotNil(selectedColor, "Didn't create a color")
        let disabledColor = Color(color: PlatformColor.gray)
        XCTAssertNotNil(disabledColor, "Didn't create a color")
        
        let colorSet = ColorSet(normalColor: normalColor!, highlightedColor: highlightedColor!, selectedColor: selectedColor!, disabledColor: disabledColor!)
        XCTAssert(normalColor! == colorSet.normalColor, "Colors don't match")
        XCTAssert(highlightedColor! == colorSet.highlightedColor, "Colors don't match")
        XCTAssert(selectedColor! == colorSet.selectedColor, "Colors don't match")
        XCTAssert(disabledColor! == colorSet.disabledColor, "Colors don't match")
    }
}

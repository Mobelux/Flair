//
//  ColorSetTests.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
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

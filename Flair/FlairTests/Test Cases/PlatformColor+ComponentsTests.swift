//
//  PlatformColor+ComponentsTests.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair

class PlatformColor_ComponentsTests: XCTestCase {
    
    func test_OpaqueColor() {
        let color = PlatformColor(red: 100, green: 100, blue: 100, alpha: 1)
        XCTAssert(color.opaque, "The color was not opaque, but it should be")
    }
    
    func test_TransparentColor() {
        let color = PlatformColor(red: 255, green: 100, blue: 0, alpha: 0.25)
        XCTAssertFalse(color.opaque, "The color was opaque, but it should NOT be")
    }
    
    func test_InvalidColor() {
        #if os(iOS) || os(tvOS)
            typealias Image = UIImage
        #elseif os(OSX)
            typealias Image = NSImage
        #endif
        let image = Image()
        let platformColor = PlatformColor(patternImage: image)
        let color = platformColor.getColor()
        XCTAssertNil(color, "We shouldn't be able to get components from a pattern image generated color")
    }
}

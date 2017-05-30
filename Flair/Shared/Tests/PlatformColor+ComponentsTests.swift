//
//  PlatformColor+ComponentsTests.swift
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

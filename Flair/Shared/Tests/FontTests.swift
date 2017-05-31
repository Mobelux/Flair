//
//  FontTests.swift
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

class FontTests: XCTestCase {
    
    
    func testFontInitNameSize() {
        let size: CGFloat = 24
        let sizeType = Font.SizeType.staticSize(pointSize: size)
        
        let fontName = "Helvetica"
        let font = Font(fontName: fontName, sizeType: sizeType)
        guard let platformFont = font.font else {
            XCTAssert(false, "Couldn't unwrap platformFont")
            return
        }
        XCTAssert(platformFont.fontName == fontName, "Font name mismatch")
        XCTAssert(platformFont.pointSize == size, "Font size mismatch")
    }
    
    func testInvalidFontName() {
        let fontName = "FakeFontName"
        let font = Font(fontName: fontName, sizeType: .staticSize(pointSize: 10))
        XCTAssertNil(font.font, "Font wasn't nil but it should be")
    }
    
    func testEquality() {
        let fontName = "Helvetica"
        
        let sizeType0 = Font.SizeType.staticSize(pointSize: 10)
        let sizeType1 = Font.SizeType.staticSize(pointSize: 11)
        let sizeType2 = Font.SizeType.dynamicSize(pointSizeBase: 10)
        let sizeType3 = Font.SizeType.dynamicSize(pointSizeBase: 11)
        
        XCTAssert(sizeType0 == sizeType0, "SizeTypes should be equal")
        XCTAssert(sizeType0 != sizeType1, "SizeTypes shouldn't be equal")
        XCTAssert(sizeType0 != sizeType2, "SizeTypes shouldn't be equal")
        XCTAssert(sizeType2 == sizeType2, "SizeTypes should be equal")
        
        let font0 = Font(fontName: fontName, sizeType: sizeType0)
        let font1 = Font(fontName: fontName, sizeType: sizeType0)
        let font2 = Font(fontName: fontName, sizeType: sizeType1)
        let font3 = Font(fontName: "Helvetica-Bold", sizeType: sizeType3)
        
        XCTAssert(font0 == font1, "Fonts should be equal")
        XCTAssertFalse(font1 == font2, "Fonts shouldn't be equal")
        XCTAssertFalse(font0 == font3, "Fonts shouldn't be equal")
    }
    
    func testSystemFont() {
        let size: CGFloat = 26
        let sizeType = Font.SizeType.dynamicSize(pointSizeBase: size)
        let weight = Font.Weight.bold
        
        let font = Font(type: .system(weight: weight), sizeType: sizeType)
        XCTAssertNotNil(font.font, "Font was nil, but shouldn't be")
    }
}

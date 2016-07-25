//
//  FontTests.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
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
        let sizeType2 = Font.SizeType.dynamic(pointSizeBase: 10)
        let sizeType3 = Font.SizeType.dynamic(pointSizeBase: 11)
        
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
        let sizeType = Font.SizeType.dynamic(pointSizeBase: size)
        let weight = Font.Weight.bold
        
        let font = Font(type: .system(weight: weight), sizeType: sizeType)
        XCTAssertNotNil(font.font, "Font was nil, but shouldn't be")
    }
}

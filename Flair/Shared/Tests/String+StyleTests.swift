//
//  String+StyleTests.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair

class String_StyleTests: XCTestCase {
    
    func testAttributedStringSimpleCreation() {
        let string = "Once upon a time there was a plain string"
        let font = Font(fontName: "helvetica", sizeType: .staticSize(pointSize: 24))
        let colorSet = ColorSet(normalColor: Color(red: 1, green: 0, blue: 0, alpha: 1))
        
        let style = Style(font: font, kerning: 2, lineHeightMultiple: 3, textColor: colorSet)
        let attributedString = string.attributedString(for: style)
        XCTAssert(attributedString.string == string, "Strings don't match")
        
        let manualAttributedString = NSAttributedString(string: string, attributes: style.textAttributes())
        XCTAssert(manualAttributedString == attributedString, "Attributed strings don't match")
    }
    
    func testAttributedStringAdvancedCreationDefaultValues() {
        let string = "Once upon a time there was an advanced string"
        let font = Font(fontName: "helvetica", sizeType: .staticSize(pointSize: 24))
        let colorSet = ColorSet(normalColor: Color(red: 1, green: 0, blue: 0, alpha: 1))
        
        let style = Style(font: font, kerning: 2, lineHeightMultiple: 3, textColor: colorSet)
        
        let textAlignment = NSTextAlignment.center
        let lineBreakMode = NSLineBreakMode.byCharWrapping
        
        let attributedString = string.attributedString(for: style, alignment: textAlignment, lineBreakMode: lineBreakMode)
        XCTAssert(attributedString.string == string, "Strings don't match")
        
        let attributes = style.textAttributes(alignment: textAlignment, lineBreakMode: lineBreakMode)
        let manualAttributedString = NSAttributedString(string: string, attributes: attributes)
        XCTAssert(manualAttributedString == attributedString, "Attributed strings don't match")
    }
    
}

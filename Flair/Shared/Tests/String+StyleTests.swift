//
//  String+StyleTests.swift
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

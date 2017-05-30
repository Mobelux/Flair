//
//  UILabel+StyleTests.swift
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

class UILabel_StyleTests: XCTestCase {
    
    func testBasicStyle() {
        let font = Font(systemFontWeight: .medium, sizeType: .staticSize(pointSize: 14))
        let color = Color(red: 0, green: 1, blue: 0, alpha: 1)
        let colorSet = ColorSet(normalColor: color)
        let style = Style(font: font, textColor: colorSet)
        
        let initialText = "This text should be set on the label, before setting the style"
        
        let label = UILabel()
        label.text = initialText
        label.style = style
        
        XCTAssert(label.style == style, "The style we just set doesn't match the style it has now")
        XCTAssert(label.textColor == color.color, "The text color isn't right")
        XCTAssert(label.font == font.font, "The font doesn't match")
        XCTAssert(label.text == initialText, "The text doesn't match")
        label.text = nil
        label.setStyled(text: initialText)
        XCTAssert(label.text == initialText, "The text doesn't match")
    }
    
    func testAdvancedStyle() {
        let font = Font(systemFontWeight: .medium, sizeType: .staticSize(pointSize: 14))
        let color = Color(red: 0, green: 1, blue: 0, alpha: 1)
        let colorSet = ColorSet(normalColor: color)
        let style = Style(font: font, kerning: 2, lineHeightMultiple: 2.6, textColor: colorSet)
        
        let initialText = "This text should be set on the label, before setting the style"
        
        let label = UILabel()
        label.text = initialText
        label.numberOfLines = 0
        label.style = style
        label.textAlignment = .center
        
        XCTAssert(label.style == style, "The style we just set doesn't match the style it has now")
        XCTAssert(label.text == initialText, "The text doesn't match")
        label.text = nil
        label.setStyled(text: initialText)
        XCTAssert(label.text == initialText, "The text doesn't match")

        let expectedAttributedString = initialText.attributedString(for: style, alignment: label.textAlignment, lineBreakMode: label.lineBreakMode)
        XCTAssert(label.attributedText == expectedAttributedString, "Attributed string doesn't match expected")
    }
}

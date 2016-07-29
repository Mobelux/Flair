//
//  UILabel+StyleTests.swift
//  Flair
//
//  Created by Jerry Mayers on 7/22/16.
//  Copyright © 2016 Mobelux. All rights reserved.
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
        let style = Style(font: font, kerning: 2, lineSpacing: 26, textColor: colorSet)
        
        let initialText = "This text should be set on the label, before setting the style"
        
        let label = UILabel()
        label.text = initialText
        label.style = style
        
        XCTAssert(label.style == style, "The style we just set doesn't match the style it has now")
        XCTAssert(label.text == initialText, "The text doesn't match")
        label.text = nil
        label.setStyled(text: initialText)
        XCTAssert(label.text == initialText, "The text doesn't match")
        
        let expectedAttributedString = initialText.attributedString(for: style)
        XCTAssert(label.attributedText == expectedAttributedString, "Attributed string doesn't match expected")
    }
}

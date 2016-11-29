//
//  UITextField+StyleTests.swift
//  Flair
//
//  Created by Jerry Mayers on 11/28/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair

class UITextField_StyleTests: XCTestCase {
    
    func testBasicStyle() {
        let font = Font(systemFontWeight: .medium, sizeType: .staticSize(pointSize: 14))
        let color = Color(red: 0, green: 1, blue: 0, alpha: 1)
        let colorSet = ColorSet(normalColor: color)
        let style = Style(font: font, textColor: colorSet)

        let initialText = "This text should be set on the text field, before setting the style"

        let field = UITextField()
        field.text = initialText
        field.style = style

        XCTAssert(field.style == style, "The style we just set doesn't match the style it has now")
        XCTAssert(field.textColor == color.color, "The text color isn't right")
        XCTAssert(field.font == font.font, "The font doesn't match")
        XCTAssert(field.text == initialText, "The text doesn't match")
    }

    func testAdvancedStyle() {
        let font = Font(systemFontWeight: .medium, sizeType: .staticSize(pointSize: 14))
        let color = Color(red: 0, green: 1, blue: 0, alpha: 1)
        let colorSet = ColorSet(normalColor: color)
        let style = Style(font: font, kerning: 2, lineHeightMultiple: 2.6, textColor: colorSet)

        let initialText = "This text should be set on the text field, before setting the style"

        let field = UITextField()
        field.text = initialText
        field.textAlignment = .center
        field.style = style

        XCTAssert(field.style == style, "The style we just set doesn't match the style it has now")
        XCTAssert(field.text == initialText, "The text doesn't match")

        let expectedAttributes = style.textAttributes()
        let expectedFont = expectedAttributes[NSFontAttributeName] as? UIFont
        XCTAssertNotNil(expectedFont, "Font missing")
        let expectedTextColor = expectedAttributes[NSForegroundColorAttributeName] as? UIColor
        XCTAssertNotNil(expectedTextColor, "Text color missing")

        XCTAssertNotNil(field.attributedText, "Attributed text was nil")
        guard let attributedText = field.attributedText else { return }

        let range = NSRange(0..<attributedText.string.characters.count)
        var fontFound = false
        var colorFound = false

        attributedText.enumerateAttributes(in: range, options: []) { (attributes, range, stop) in
            if let color = attributes[NSForegroundColorAttributeName] as? UIColor {
                colorFound = true
                XCTAssert(color == expectedTextColor, "Text color doesn't match")
            }
            if let font = attributes[NSFontAttributeName] as? UIFont {
                fontFound = true
                XCTAssert(font == expectedFont, "Font doesn't match")
            }
        }

        XCTAssert(fontFound, "Didn't find a matching font")
        XCTAssert(colorFound, "Didn't find a matching color")
        // Ideally we should test for the kerning, however the `attributedText` coming out of the text field will never have that (bug in UIKit?). But a visual inspection shows that the displayed text respects it. :(
    }
}

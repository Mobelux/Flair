//
//  UIButton+StyleTests.swift
//  Flair
//
//  Created by Jerry Mayers on 11/22/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair

class UIButton_StyleTests: XCTestCase {

    func testStyleTitleColorSet() {
        let red = Color(color: UIColor.red)!
        let green = Color(color: UIColor.green)!
        let blue = Color(color: UIColor.blue)!
        let redFaded = Color(color: UIColor.red.withAlphaComponent(0.25))!

        let colorSet = ColorSet(normalColor: red, highlightedColor: green, selectedColor: blue, disabledColor: redFaded)
        let font = Font(systemFontWeight: .medium, sizeType: .staticSize(pointSize: 14))
        let style = Style(font: font, textColor: colorSet)

        let button = UIButton(type: .custom)
        button.style = style
        XCTAssert(button.titleColorSet() == colorSet, "Color set doesn't match")
        XCTAssert(button.titleColor(for: .normal) == red.color, "Normal color doesn't match")
        XCTAssert(button.titleColor(for: .highlighted) == green.color, "Highlighted color doesn't match")
        XCTAssert(button.titleColor(for: .selected) == blue.color, "Selected color doesn't match")
        XCTAssert(button.titleColor(for: .disabled) == redFaded.color, "Disabled color doesn't match")
    }
    
    func testBasicStyle() {
        let font = Font(systemFontWeight: .medium, sizeType: .staticSize(pointSize: 14))
        let color = Color(red: 0, green: 1, blue: 0, alpha: 1)
        let colorSet = ColorSet(normalColor: color)
        let style = Style(font: font, textColor: colorSet)

        let initialNormalText = "Normal"
        let initialHighlightedText = "Highlighted"
        let initialSelectedText = "Selected"
        let initialDisabledText = "Disabled"

        let button = UIButton(type: .system)
        button.setTitle(initialNormalText, for: .normal)
        button.setTitle(initialHighlightedText, for: .highlighted)
        button.setTitle(initialSelectedText, for: .selected)
        button.setTitle(initialDisabledText, for: .disabled)

        button.style = style

        XCTAssert(button.style == style, "The style we just set doesn't match the style it has now")
        XCTAssert(button.titleLabel?.font == font.font, "The font doesn't match")
    }

    func testAdvancedStyle() {
        let font = Font(systemFontWeight: .medium, sizeType: .staticSize(pointSize: 14))
        let color = Color(red: 0, green: 1, blue: 0, alpha: 1)
        let colorSet = ColorSet(normalColor: color)
        let style = Style(font: font, kerning: 2, lineHeightMultiple: 2.6, textColor: colorSet)

        let initialNormalText = "Normal"
        let initialHighlightedText = "Highlighted"
        let initialSelectedText = "Selected"
        let initialDisabledText = "Disabled"

        let button = UIButton(type: .system)
        button.setTitle(initialNormalText, for: .normal)
        button.setTitle(initialHighlightedText, for: .highlighted)
        button.setTitle(initialSelectedText, for: .selected)
        button.setTitle(initialDisabledText, for: .disabled)

        button.style = style

        XCTAssert(button.style == style, "The style we just set doesn't match the style it has now")

        let alignment = button.titleLabel?.textAlignment ?? .center
        let lineBreakMode = button.titleLabel?.lineBreakMode ?? .byTruncatingMiddle
        let attributes = style.textAttributes(alignment: alignment, lineBreakMode: lineBreakMode, multiline: false)

        let expectedNormalText = NSAttributedString(string: initialNormalText, attributes: attributes)
        XCTAssert(expectedNormalText == button.attributedTitle(for: .normal), "The normal text doesn't match")

        let expectedHighlightedText = NSAttributedString(string: initialHighlightedText, attributes: attributes)
        XCTAssert(expectedHighlightedText == button.attributedTitle(for: .highlighted), "The highlighted text doesn't match")

        let expectedSelectedText = NSAttributedString(string: initialSelectedText, attributes: attributes)
        XCTAssert(expectedSelectedText == button.attributedTitle(for: .selected), "The selected text doesn't match")

        let expectedDisabledText = NSAttributedString(string: initialDisabledText, attributes: attributes)
        XCTAssert(expectedDisabledText == button.attributedTitle(for: .disabled), "The disabled text doesn't match")
    }}

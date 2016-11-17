//
//  StyleTests.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair

class StyleTests: XCTestCase {
    
    func systemFont() -> Font {
        return Font(systemFontWeight: .regular, sizeType: .dynamicSize(pointSizeBase: 17))
    }
    
    func testStyleLineSpacingFixing() {
        let style = Style(font: systemFont(), lineHeightMultiple: -25)
        XCTAssert(style.lineHeightMultiple == 0, "Line height wasn't clamped to 0")
        
        let lineHeightMultiple: CGFloat = 2.5
        let style2 = Style(font: systemFont(), lineHeightMultiple: lineHeightMultiple)
        XCTAssert(style2.lineHeightMultiple == lineHeightMultiple, "Line height doesn't match input")
    }
    
    func testStyleTextColorChange() {
        let textColor0 = ColorSet(normalColor: Color(color: PlatformColor.red)!)
        let style0 = Style(font: systemFont(), textColor: textColor0)
        XCTAssertNotNil(style0.textColor, "textColor shouldn't be nil")
        guard let style0TextColor = style0.textColor else { return }
        XCTAssert(style0TextColor == textColor0, "textColors don't match")
        
        let textColor1 = ColorSet(normalColor: Color(color: PlatformColor.green)!)
        let style1 = Style(style: style0, textColor: textColor1)
        XCTAssertNotNil(style1.textColor, "textColor shouldn't be nil")
        guard let style1TextColor = style1.textColor else { return }
        XCTAssert(style1TextColor == textColor1, "textColors don't match")
    }
    
    func testTextAttributes() {
        let textColor = ColorSet(normalColor: Color(color: PlatformColor.red)!)
        let style = Style(font: systemFont(), kerning: 2, lineHeightMultiple: 2.0, textColor: textColor)
        let alignment = NSTextAlignment.center
        let lineBreakMode = NSLineBreakMode.byCharWrapping
        let attributes = style.textAttributes(alignment: alignment, lineBreakMode: lineBreakMode)
        
        XCTAssert(attributes.keys.contains(NSFontAttributeName), "Font not included")
        guard let font = attributes[NSFontAttributeName] as? PlatformFont else { return }
        XCTAssert(font == style.font.font, "Fonts don't match")
        
        XCTAssert(attributes.keys.contains(NSForegroundColorAttributeName), "Text color not included")
        guard let foundTextColor = attributes[NSForegroundColorAttributeName] as? PlatformColor, let styleTextColor = style.textColor else { return }
        XCTAssert(foundTextColor == styleTextColor.normalColor.color, "Text color doesn't match")
        
        XCTAssert(attributes.keys.contains(NSKernAttributeName), "Kerning not included")
        guard let kerning = attributes[NSKernAttributeName] as? CGFloat else { return }
        XCTAssert(kerning == style.kerning, "Kerning doesn't match")
        
        XCTAssert(attributes.keys.contains(NSParagraphStyleAttributeName), "Paragraph style not included")
        guard let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle else { return }
        XCTAssert(paragraphStyle.lineBreakMode == lineBreakMode, "Line break mode doesn't match")
        XCTAssert(paragraphStyle.alignment == alignment, "Alignment doesn't match")
        XCTAssert(paragraphStyle.lineHeightMultiple == style.lineHeightMultiple, "lineHeightMultiple doesn't match")
    }
}

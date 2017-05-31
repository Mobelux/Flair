//
//  StyleTests.swift
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
        let inutFont = systemFont()
        guard let platformFont = inutFont.font else {
            XCTAssert(false, "Couldn't get a font")
            return
        }
        let lineHeightMultiple: CGFloat = 2.0
        let expectedLineSpacing = (lineHeightMultiple * platformFont.pointSize - platformFont.pointSize) / 2

        let textColor = ColorSet(normalColor: Color(color: PlatformColor.red)!)
        let style = Style(font: inutFont, kerning: 2, lineHeightMultiple: lineHeightMultiple, textColor: textColor)
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
        XCTAssert(paragraphStyle.lineSpacing == expectedLineSpacing, "lineSpacing not what we expected")
    }
}

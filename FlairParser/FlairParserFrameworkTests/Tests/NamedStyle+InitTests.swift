//
//  NamedStyle+InitTests.swift
//  FlairParser
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
@testable import FlairParserFramework

class NamedStyle_InitTests: XCTestCase {
    
    func testValidStyle() {
        let colorName = "brandBlue"
        let color = NamedColorSet(name: colorName, normalColor: Color(red: 0, green: 0, blue: 0.75, alpha: 1))
        
        let fontSize: CGFloat = 25
        let fontName = "Arial-Black"
        let fontValue: JSON = ["size" : fontSize as NSNumber, "fontName" : fontName, "sizeType" : "static"]
        
        let lineHeightMultiple: CGFloat = 3.4
        let kerning: CGFloat = 3
        
        let styleValues: JSON = ["font" : fontValue, "lineHeightMultiple" : lineHeightMultiple as NSNumber, "kerning" : kerning as NSNumber, "textColor" : colorName]
        let styleName = "title"
        
        let expectedFont = Font(fontName: fontName, sizeType: .staticSize(pointSize: fontSize))
        let expectedStyle = NamedStyle(name: styleName, font: expectedFont, kerning: kerning, lineHeightMultiple: lineHeightMultiple, textColor: color)
        
        do {
            let style = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssert(style.textColor == color, "TextColor is incorrect")
            XCTAssert(style.lineHeightMultiple == lineHeightMultiple, "lineHeightMultiple is incorrect")
            XCTAssert(style.kerning == kerning, "Kerning is incorrect")
            XCTAssert(style.name == styleName, "Style name is incorrect")
            XCTAssertFalse(style.isBasicStyle, "Should not be a basic style")
            
            switch style.font.sizeType {
            case .staticSize(let size):
                XCTAssert(size == fontSize, "Font size incorrect")
            case .dynamicSize:
                XCTAssert(false, "Should be a static size")
            }
            
            switch style.font.type {
            case .normal(let fontN):
                XCTAssert(fontN == fontName, "Font name incorrect")
            case .system:
                XCTAssert(false, "Should be a normal font")
            }
            
            XCTAssert(expectedStyle == style, "Expected style doesn't match created style")
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testMissingFont() {
        let colorName = "brandBlue"
        let color = NamedColorSet(name: colorName, normalColor: Color(red: 0, green: 0, blue: 0.75, alpha: 1))
        
        let lineSpacing: CGFloat = 34
        let kerning: CGFloat = 3
        
        let styleValues: JSON = ["lineSpacing" : lineSpacing as NSNumber, "kerning" : kerning as NSNumber, "textColor" : colorName]
        let styleName = "title"
        
        do {
            let _ = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssert(false, "Shouldn't have a valid style")
        } catch Parser.ParserError.missingFontDict {
            // Expected case
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testTextColorMismatch() {
        let colorName = "brandBlue"
        let color = NamedColorSet(name: "other name", normalColor: Color(red: 0, green: 0, blue: 0.75, alpha: 1))
        
        let fontSize: CGFloat = 25
        let fontName = "Arial-Black"
        let fontValue: JSON = ["size" : fontSize as NSNumber, "fontName" : fontName, "sizeType" : "static"]
        
        let lineSpacing: CGFloat = 34
        let kerning: CGFloat = 3
        
        let styleValues: JSON = ["font" : fontValue, "lineSpacing" : lineSpacing as NSNumber, "kerning" : kerning as NSNumber, "textColor" : colorName]
        let styleName = "title"
        
        do {
            let style = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssertNil(style.textColor, "TextColor should be nil")
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testTextColorMissing() {
        let color = NamedColorSet(name: "other name", normalColor: Color(red: 0, green: 0, blue: 0.75, alpha: 1))
        
        let fontSize: CGFloat = 25
        let fontName = "Arial-Black"
        let fontValue: JSON = ["size" : fontSize as NSNumber, "fontName" : fontName, "sizeType" : "static"]
        
        let lineSpacing: CGFloat = 34
        let kerning: CGFloat = 3
        
        let styleValues: JSON = ["font" : fontValue, "lineSpacing" : lineSpacing as NSNumber, "kerning" : kerning as NSNumber]
        let styleName = "title"
        
        do {
            let style = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssertNil(style.textColor, "TextColor should be nil")
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testKerningMissing() {
        let colorName = "brandBlue"
        let color = NamedColorSet(name: colorName, normalColor: Color(red: 0, green: 0, blue: 0.75, alpha: 1))
        
        let fontSize: CGFloat = 25
        let fontName = "Arial-Black"
        let fontValue: JSON = ["size" : fontSize as NSNumber, "fontName" : fontName, "sizeType" : "static"]
        
        let lineSpacing: CGFloat = 34
        
        let styleValues: JSON = ["font" : fontValue, "lineSpacing" : lineSpacing as NSNumber, "textColor" : colorName]
        let styleName = "title"
        
        do {
            let style = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssert(style.kerning == 0, "Kerning incorrect")
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testLineSpacingMissing() {
        let colorName = "brandBlue"
        let color = NamedColorSet(name: colorName, normalColor: Color(red: 0, green: 0, blue: 0.75, alpha: 1))
        
        let fontSize: CGFloat = 25
        let fontName = "Arial-Black"
        let fontValue: JSON = ["size" : fontSize as NSNumber, "fontName" : fontName, "sizeType" : "static"]
        
        let kerning: CGFloat = 4
        
        let styleValues: JSON = ["font" : fontValue, "kerning" : kerning as NSNumber, "textColor" : colorName]
        let styleName = "title"
        
        do {
            let style = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssert(style.lineHeightMultiple == 0, "lineHeightMultiple incorrect")
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

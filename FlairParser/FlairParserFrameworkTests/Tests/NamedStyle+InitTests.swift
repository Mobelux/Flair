//
//  NamedStyle+InitTests.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/26/16.
//  Copyright © 2016 Mobelux. All rights reserved.
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
        let fontValue: JSON = ["size" : fontSize, "fontName" : fontName, "sizeType" : "static"]
        
        let lineSpacing: CGFloat = 34
        let kerning: CGFloat = 3
        
        let styleValues: JSON = ["font" : fontValue, "lineSpacing" : lineSpacing, "kerning" : kerning, "textColor" : colorName]
        let styleName = "title"
        
        let expectedFont = Font(fontName: fontName, sizeType: .staticSize(pointSize: fontSize))
        let expectedStyle = NamedStyle(name: styleName, font: expectedFont, kerning: kerning, lineSpacing: lineSpacing, textColor: color)
        
        do {
            let style = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssert(style.textColor == color, "TextColor is incorrect")
            XCTAssert(style.lineSpacing == lineSpacing, "LineSpacing is incorrect")
            XCTAssert(style.kerning == kerning, "Kerning is incorrect")
            XCTAssert(style.name == styleName, "Style name is incorrect")
            XCTAssertFalse(style.isBasicStyle, "Should not be a basic style")
            
            switch style.font.sizeType {
            case .staticSize(let size):
                XCTAssert(size == fontSize, "Font size incorrect")
            case .dynamic:
                XCTAssert(false, "Should be a static size")
            }
            
            switch style.font.type {
            case .normal(let fontN):
                XCTAssert(fontN == fontName, "Font name incorrect")
            case .system:
                XCTAssert(false, "Should be a normal font")
            }
            
            XCTAssert(expectedStyle == style, "Expected style doesn't match created style")
        } catch let error as Parser.Error {
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
        
        let styleValues: JSON = ["lineSpacing" : lineSpacing, "kerning" : kerning, "textColor" : colorName]
        let styleName = "title"
        
        do {
            let _ = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssert(false, "Shouldn't have a valid style")
        } catch Parser.Error.missingFontDict {
            // Expected case
        } catch let error as Parser.Error {
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
        let fontValue: JSON = ["size" : fontSize, "fontName" : fontName, "sizeType" : "static"]
        
        let lineSpacing: CGFloat = 34
        let kerning: CGFloat = 3
        
        let styleValues: JSON = ["font" : fontValue, "lineSpacing" : lineSpacing, "kerning" : kerning, "textColor" : colorName]
        let styleName = "title"
        
        do {
            let style = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssertNil(style.textColor, "TextColor should be nil")
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testTextColorMissing() {
        let color = NamedColorSet(name: "other name", normalColor: Color(red: 0, green: 0, blue: 0.75, alpha: 1))
        
        let fontSize: CGFloat = 25
        let fontName = "Arial-Black"
        let fontValue: JSON = ["size" : fontSize, "fontName" : fontName, "sizeType" : "static"]
        
        let lineSpacing: CGFloat = 34
        let kerning: CGFloat = 3
        
        let styleValues: JSON = ["font" : fontValue, "lineSpacing" : lineSpacing, "kerning" : kerning]
        let styleName = "title"
        
        do {
            let style = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssertNil(style.textColor, "TextColor should be nil")
        } catch let error as Parser.Error {
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
        let fontValue: JSON = ["size" : fontSize, "fontName" : fontName, "sizeType" : "static"]
        
        let lineSpacing: CGFloat = 34
        
        let styleValues: JSON = ["font" : fontValue, "lineSpacing" : lineSpacing, "textColor" : colorName]
        let styleName = "title"
        
        do {
            let style = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssert(style.kerning == 0, "Kerning incorrect")
        } catch let error as Parser.Error {
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
        let fontValue: JSON = ["size" : fontSize, "fontName" : fontName, "sizeType" : "static"]
        
        let kerning: CGFloat = 4
        
        let styleValues: JSON = ["font" : fontValue, "kerning" : kerning, "textColor" : colorName]
        let styleName = "title"
        
        do {
            let style = try NamedStyle(name: styleName, styleValues: styleValues, colors: [color])
            XCTAssert(style.lineSpacing == 0, "Line spacing incorrect")
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

//
//  Font+InitTests.swift
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

class Font_InitTests: XCTestCase {
    
    func testValidNormalFont() {
        let fontSize: CGFloat = 12
        let fontName = "Arial-Black"
        let fontValues: JSON = ["size" : fontSize as NSNumber, "fontName" : fontName, "sizeType" : "static"]
        do {
            let font = try Font(fontValues: fontValues)
            switch font.sizeType {
            case .staticSize(let size):
                XCTAssert(size == fontSize, "Font size mismatch")
            case .dynamicSize:
                XCTAssert(false, "We should have a static font")
            }
            
            switch font.type {
            case .normal(let name):
                XCTAssert(name == fontName, "Font name mismatch")
            case .system:
                XCTAssert(false, "We should have a normal font")
            }
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testValidSystemFont() {
        let fontSize: CGFloat = 22
        let fontWeight = "medium"
        let fontValues: JSON = ["size" : fontSize as NSNumber, "systemFontWeight" : fontWeight, "sizeType" : "dynamic"]
        do {
            let font = try Font(fontValues: fontValues)
            switch font.sizeType {
            case .staticSize:
                XCTAssert(false, "We should have a dynamic font")
            case .dynamicSize(let size):
                
                XCTAssert(size == fontSize, "Font size mismatch")
            }
            
            switch font.type {
            case .normal:
                XCTAssert(false, "We should have a system font")
            case .system(let weight):
                XCTAssert(weight.rawValue == fontWeight, "Font weight mismatch")
            }
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testMissingSize() {
        let fontSize = "invalid"
        let fontName = "Arial-Black"
        let fontValues: JSON = ["size" : fontSize, "fontName" : fontName, "sizeType" : "static"]
        do {
            let _ = try Font(fontValues: fontValues)
            XCTAssert(false, "We shouldn't have font")
        } catch Parser.ParserError.invalidFontValue {
            // Expected case
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testMissingFontName() {
        let fontSize: CGFloat = 12
        let fontValues: JSON = ["size" : fontSize as NSNumber, "sizeType" : "static"]
        
        do {
            let _ = try Font(fontValues: fontValues)
            XCTAssert(false, "We shouldn't have font")
        } catch Parser.ParserError.invalidFontValue {
            // Expected case
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testMissingSizeType() {
        let fontSize: CGFloat = 12
        let fontName = "Arial-Black"
        let fontValues: JSON = ["size" : fontSize as NSNumber, "fontName" : fontName, "sizeType" : "random"]
        
        do {
            let _ = try Font(fontValues: fontValues)
            XCTAssert(false, "We shouldn't have font")
        } catch Parser.ParserError.invalidFontValue {
            // Expected case
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

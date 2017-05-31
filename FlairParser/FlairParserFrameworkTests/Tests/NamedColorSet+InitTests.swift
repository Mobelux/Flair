//
//  NamedColorSet+InitTests.swift
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

class NamedColorSet_InitTests: XCTestCase {

    func testValidCompleteColorSet() {
        let normal = "rgba(0.0, 1.0, 0.5, 1.0)"
        let highlighted = "rgba(1.0, 0.0, 0.0, 0.5)"
        let selected = "rgba(0.25, 0.5, 0.75, 1.0)"
        let disabled = "rgba(1.0, 1.0, 1, 1)"
        
        let colorValues: JSON = ["normal" : normal, "highlighted" : highlighted, "selected" : selected, "disabled" : disabled]
        
        do {
            let colorSet = try NamedColorSet(name: "Test", colorValues: colorValues)
            
            XCTAssert(colorSet.normalColor.red == 0, "Red is incorrect")
            XCTAssert(colorSet.normalColor.green == 1, "Green is incorrect")
            XCTAssert(colorSet.normalColor.blue == 0.5, "Blue is incorrect")
            XCTAssert(colorSet.normalColor.alpha == 1, "Alpha is incorrect")
            
            XCTAssert(colorSet.highlightedColor!.red == 1, "Red is incorrect")
            XCTAssert(colorSet.highlightedColor!.green == 0, "Green is incorrect")
            XCTAssert(colorSet.highlightedColor!.blue == 0, "Blue is incorrect")
            XCTAssert(colorSet.highlightedColor!.alpha == 0.5, "Alpha is incorrect")
            
            XCTAssert(colorSet.selectedColor!.red == 0.25, "Red is incorrect")
            XCTAssert(colorSet.selectedColor!.green == 0.5, "Green is incorrect")
            XCTAssert(colorSet.selectedColor!.blue == 0.75, "Blue is incorrect")
            XCTAssert(colorSet.selectedColor!.alpha == 1, "Alpha is incorrect")
            
            XCTAssert(colorSet.disabledColor!.red == 1, "Red is incorrect")
            XCTAssert(colorSet.disabledColor!.green == 1, "Green is incorrect")
            XCTAssert(colorSet.disabledColor!.blue == 1, "Blue is incorrect")
            XCTAssert(colorSet.disabledColor!.alpha == 1, "Alpha is incorrect")
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testValidPartialColorSet() {
        let normal = "rgba(0.0, 1.0, 0.5, 1.0)"
        let disabled = "rgba(1.0, 1.0, 1, 1)"
        
        let colorValues: JSON = ["normal" : normal, "disabled" : disabled]
        
        do {
            let colorSet = try NamedColorSet(name: "Test", colorValues: colorValues)
            
            XCTAssert(colorSet.normalColor.red == 0, "Red is incorrect")
            XCTAssert(colorSet.normalColor.green == 1, "Green is incorrect")
            XCTAssert(colorSet.normalColor.blue == 0.5, "Blue is incorrect")
            XCTAssert(colorSet.normalColor.alpha == 1, "Alpha is incorrect")
            
            XCTAssert(colorSet.disabledColor!.red == 1, "Red is incorrect")
            XCTAssert(colorSet.disabledColor!.green == 1, "Green is incorrect")
            XCTAssert(colorSet.disabledColor!.blue == 1, "Blue is incorrect")
            XCTAssert(colorSet.disabledColor!.alpha == 1, "Alpha is incorrect")
            
            XCTAssertNil(colorSet.selectedColor, "Selected color not nil")
            XCTAssertNil(colorSet.highlightedColor, "Highlighted color not nil")
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testValidMinimalColorSet() {
        let normal = "rgba(0.0, 1.0, 0.5, 1.0)"
        
        let colorValues: JSON = ["normal" : normal]
        
        do {
            let colorSet = try NamedColorSet(name: "Test", colorValues: colorValues)
            
            XCTAssert(colorSet.normalColor.red == 0, "Red is incorrect")
            XCTAssert(colorSet.normalColor.green == 1, "Green is incorrect")
            XCTAssert(colorSet.normalColor.blue == 0.5, "Blue is incorrect")
            XCTAssert(colorSet.normalColor.alpha == 1, "Alpha is incorrect")
            
            XCTAssertNil(colorSet.selectedColor, "Selected color not nil")
            XCTAssertNil(colorSet.highlightedColor, "Highlighted color not nil")
            XCTAssertNil(colorSet.disabledColor, "Disabled color not nil")
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testInvalidNoColorSet() {
        let colorValues: JSON = [:]
        
        do {
            let _ = try NamedColorSet(name: "Test", colorValues: colorValues)
            XCTAssert(false, "We shouldn't have a valid color set")
        } catch Parser.ParserError.missingStandardColor {
            // Expected ParserError
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }

    func testInvalidColorColorSet() {
        let normal = "r(0.0, 1.0, 0.5, 1.0)"
        
        let colorValues: JSON = ["normal" : normal]
        
        do {
            let _ = try NamedColorSet(name: "Test", colorValues: colorValues)
            XCTAssert(false, "We shouldn't have a valid color set")
        } catch Parser.ParserError.invalidColorValue {
            // Expected Case
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

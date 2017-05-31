//
//  Color+InitTests.swift
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

class Color_InitTests: XCTestCase {

    func testValidColor() {
        let value = "rgba(0.0, 1.0, 0.25, 1.0)"
        
        do {
            let color = try Color(string: value)
            XCTAssert(color.red == 0, "Red is incorrect")
            XCTAssert(color.green == 1, "Green is incorrect")
            XCTAssert(color.blue == 0.25, "Blue is incorrect")
            XCTAssert(color.alpha == 1, "Alpha is incorrect")
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testValidColorNoSpaces() {
        let value = "rgba(0.0,1.0,0.25,1.0)"
        
        do {
            let color = try Color(string: value)
            XCTAssert(color.red == 0, "Red is incorrect")
            XCTAssert(color.green == 1, "Green is incorrect")
            XCTAssert(color.blue == 0.25, "Blue is incorrect")
            XCTAssert(color.alpha == 1, "Alpha is incorrect")
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }

    func testInvalidColorPrefix() {
        let value = "rgb(0.0, 1.0, 0.25, 1.0)"
        
        do {
            let _ = try Color(string: value)
            XCTAssert(false, "We shouldn't have a valid color")
            
        } catch Parser.ParserError.invalidColorValue {
            // Expected error
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testInvalidColorSuffix() {
        let value = "rgba(0.0, 1.0, 0.25, 1.0"
        
        do {
            let _ = try Color(string: value)
            XCTAssert(false, "We shouldn't have a valid color")
            
        } catch Parser.ParserError.invalidColorValue {
            // Expected error
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testInvalidColorComponentCount() {
        let value = "rgba(1.0, 0.25, 1.0)"
        
        do {
            let _ = try Color(string: value)
            XCTAssert(false, "We shouldn't have a valid color")
            
        } catch Parser.ParserError.invalidColorValue {
            // Expected error
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testInvalidColorComponent() {
        let value = "rgba(red, green, blue, alpha)"
        
        do {
            let _ = try Color(string: value)
            XCTAssert(false, "We shouldn't have a valid color")
            
        } catch Parser.ParserError.invalidColorValue {
            // Expected error
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

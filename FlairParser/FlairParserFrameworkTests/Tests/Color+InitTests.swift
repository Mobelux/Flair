//
//  Color+InitTests.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
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
        } catch let error as Parser.Error {
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
        } catch let error as Parser.Error {
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
            
        } catch Parser.Error.invalidColorValue {
            // Expected error
        } catch let error as Parser.Error {
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
            
        } catch Parser.Error.invalidColorValue {
            // Expected error
        } catch let error as Parser.Error {
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
            
        } catch Parser.Error.invalidColorValue {
            // Expected error
        } catch let error as Parser.Error {
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
            
        } catch Parser.Error.invalidColorValue {
            // Expected error
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

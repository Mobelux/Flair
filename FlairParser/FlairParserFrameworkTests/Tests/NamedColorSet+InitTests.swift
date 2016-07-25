//
//  NamedColorSet+InitTests.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
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
        
        let colorValues = ["normal" : normal, "highlighted" : highlighted, "selected" : selected, "disabled" : disabled]
        
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
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testValidPartialColorSet() {
        let normal = "rgba(0.0, 1.0, 0.5, 1.0)"
        let disabled = "rgba(1.0, 1.0, 1, 1)"
        
        let colorValues = ["normal" : normal, "disabled" : disabled]
        
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
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testValidMinimalColorSet() {
        let normal = "rgba(0.0, 1.0, 0.5, 1.0)"
        
        let colorValues = ["normal" : normal]
        
        do {
            let colorSet = try NamedColorSet(name: "Test", colorValues: colorValues)
            
            XCTAssert(colorSet.normalColor.red == 0, "Red is incorrect")
            XCTAssert(colorSet.normalColor.green == 1, "Green is incorrect")
            XCTAssert(colorSet.normalColor.blue == 0.5, "Blue is incorrect")
            XCTAssert(colorSet.normalColor.alpha == 1, "Alpha is incorrect")
            
            XCTAssertNil(colorSet.selectedColor, "Selected color not nil")
            XCTAssertNil(colorSet.highlightedColor, "Highlighted color not nil")
            XCTAssertNil(colorSet.disabledColor, "Disabled color not nil")
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testInvalidNoColorSet() {
        let colorValues: Parser.JSON = [:]
        
        do {
            let _ = try NamedColorSet(name: "Test", colorValues: colorValues)
            XCTAssert(false, "We shouldn't have a valid color set")
        } catch Parser.Error.missingStandardColor {
            // Expected case
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }

    func testInvalidColorColorSet() {
        let normal = "r(0.0, 1.0, 0.5, 1.0)"
        
        let colorValues = ["normal" : normal]
        
        do {
            let _ = try NamedColorSet(name: "Test", colorValues: colorValues)
            XCTAssert(false, "We shouldn't have a valid color set")
        } catch Parser.Error.invalidColorValue {
            // Expected Case
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

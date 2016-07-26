//
//  ParserTests.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair
@testable import FlairParserFramework

class ParserTests: XCTestCase {

    func testValidColors() {
        let normal = "rgba(0.0, 1.0, 0.5, 1.0)"
        let highlighted = "rgba(1.0, 0.0, 0.0, 0.5)"
        let selected = "rgba(0.25, 0.5, 0.75, 1.0)"
        let disabled = "rgba(1.0, 1.0, 1, 1)"
        
        let colorValues = ["normal" : normal, "highlighted" : highlighted, "selected" : selected, "disabled" : disabled]
        let colorNames = ["coolColor", "strangeColor"]
        let colors = [colorNames[0] : colorValues, colorNames[1] : colorValues]
        let json: Parser.JSON = ["colors" : colors, "styles" : [:]]
        
        let parser = Parser(json: json)
        
        do {
            let (namedColors, styles) = try parser.parse()
            XCTAssert(namedColors.count == colors.count, "Incorrect # of colors")
            XCTAssert(styles.count == 0, "Shouldn't have any styles")
            
            for namedColorSet in namedColors {
                XCTAssert(colorNames.contains(namedColorSet.name), "Expected name doesn't match")
            }
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testNoColorsOrStyles() {
        let json: Parser.JSON = ["colors" : [:], "styles" : [:]]
        
        let parser = Parser(json: json)
        
        do {
            let _ = try parser.parse()
            XCTAssert(false, "We should have thrown an error")
        } catch Parser.Error.noColorsOrStyles {
            // Expected case
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testMissingStyles() {
        let json: Parser.JSON = ["colors" : [:]]
        
        let parser = Parser(json: json)
        
        do {
            let _ = try parser.parse()
            XCTAssert(false, "We should have thrown an error")
        } catch Parser.Error.missingStyleDict {
            // Expected case
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testMissingColors() {
        let json: Parser.JSON = ["styles" : [:]]
        
        let parser = Parser(json: json)
        
        do {
            let _ = try parser.parse()
            XCTAssert(false, "We should have thrown an error")
        } catch Parser.Error.missingColorDict {
            // Expected case
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testValidColorsAndStyles() {
        let normal = "rgba(0.0, 1.0, 0.5, 1.0)"
        let highlighted = "rgba(1.0, 0.0, 0.0, 0.5)"
        let selected = "rgba(0.25, 0.5, 0.75, 1.0)"
        let disabled = "rgba(1.0, 1.0, 1, 1)"
        
        let colorValues = ["normal" : normal, "highlighted" : highlighted, "selected" : selected, "disabled" : disabled]
        let colorNames = ["coolColor", "strangeColor"]
        let colors = [colorNames[0] : colorValues, colorNames[1] : colorValues]
        
        let titleFontValue: Parser.JSON = ["size" : 25, "fontName" : "Arial-Black", "sizeType" : "static"]
        let titleStyleValues: Parser.JSON = ["font" : titleFontValue, "lineSpacing" : 34, "kerning" : 3, "textColor" : colorNames[0]]
        
        let bodyFontValue: Parser.JSON = ["size" : 15, "fontName" : "Arial-Black", "sizeType" : "dynamic"]
        let bodyStyleValues: Parser.JSON = ["font" : bodyFontValue, "lineSpacing" : 14, "kerning" : 1, "textColor" : colorNames[1]]
        
        let styleNames = ["title", "body"]
        let namedStyles: Parser.JSON = [styleNames[0] : titleStyleValues, styleNames[1] : bodyStyleValues]
        let json: Parser.JSON = ["colors" : colors, "styles" : namedStyles]
        
        let parser = Parser(json: json)
        
        do {
            let (namedColors, styles) = try parser.parse()
            XCTAssert(namedColors.count == colors.count, "Incorrect # of colors")
            XCTAssert(styles.count == namedStyles.count, "Incorrect # of styles")
            
            for namedColorSet in namedColors {
                XCTAssert(colorNames.contains(namedColorSet.name), "Expected name doesn't match")
            }
            
            for namedStyle in styles {
                XCTAssert(styleNames.contains(namedStyle.name), "Expected name doesn't match")
            }
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

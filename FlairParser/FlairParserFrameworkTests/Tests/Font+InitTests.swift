//
//  Font+InitTests.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair
@testable import FlairParserFramework

class Font_InitTests: XCTestCase {
    
    func testValidNormalFont() {
        let fontSize: CGFloat = 12
        let fontName = "Arial-Black"
        let fontValues: Parser.JSON = ["size" : fontSize, "fontName" : fontName, "sizeType" : "static"]
        do {
            let font = try Font(fontValues: fontValues)
            switch font.sizeType {
            case .staticSize(let size):
                XCTAssert(size == fontSize, "Font size mismatch")
            case .dynamic:
                XCTAssert(false, "We should have a static font")
            }
            
            switch font.type {
            case .normal(let name):
                XCTAssert(name == fontName, "Font name mismatch")
            case .system:
                XCTAssert(false, "We should have a normal font")
            }
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testValidSystemFont() {
        let fontSize: CGFloat = 22
        let fontWeight = "medium"
        let fontValues: Parser.JSON = ["size" : fontSize, "systemFontWeight" : fontWeight, "sizeType" : "dynamic"]
        do {
            let font = try Font(fontValues: fontValues)
            switch font.sizeType {
            case .staticSize:
                XCTAssert(false, "We should have a dynamic font")
            case .dynamic(let size):
                
                XCTAssert(size == fontSize, "Font size mismatch")
            }
            
            switch font.type {
            case .normal:
                XCTAssert(false, "We should have a system font")
            case .system(let weight):
                XCTAssert(weight.rawValue == fontWeight, "Font weight mismatch")
            }
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testMissingSize() {
        let fontSize = "invalid"
        let fontName = "Arial-Black"
        let fontValues: Parser.JSON = ["size" : fontSize, "fontName" : fontName, "sizeType" : "static"]
        do {
            let _ = try Font(fontValues: fontValues)
            XCTAssert(false, "We shouldn't have font")
        } catch Parser.Error.invalidFontValue {
            // Expected case
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testMissingFontName() {
        let fontSize: CGFloat = 12
        let fontValues: Parser.JSON = ["size" : fontSize, "sizeType" : "static"]
        
        do {
            let _ = try Font(fontValues: fontValues)
            XCTAssert(false, "We shouldn't have font")
        } catch Parser.Error.invalidFontValue {
            // Expected case
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
    
    func testMissingSizeType() {
        let fontSize: CGFloat = 12
        let fontName = "Arial-Black"
        let fontValues: Parser.JSON = ["size" : fontSize, "fontName" : fontName, "sizeType" : "random"]
        
        do {
            let _ = try Font(fontValues: fontValues)
            XCTAssert(false, "We shouldn't have font")
        } catch Parser.Error.invalidFontValue {
            // Expected case
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}
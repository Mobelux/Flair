//
//  GeneratorTests.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/27/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair
@testable import FlairParserFramework

class GeneratorTests: XCTestCase {

    func testColorAndStyleGeneration() {
        let json = Bundle(for: ParserTests.self).urlForResource("validColorAndStyle", withExtension: "json")!
        
        do {
            let parser = try Parser(json: json)
            let (colors, styles, jsonHash) = try parser.parse()
            XCTAssert(colors.count == 2, "Invalid # of colors")
            XCTAssert(styles.count == 2, "Invalid # of styles")
            XCTAssert(jsonHash.characters.count > 0, "Invalid hash")
            
            let outputDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
            let generatedColorFile = try! Generator.createFileURL(fileName: Generator.Constants.colorsFileName, outputDirectory: outputDirectory)
            let generatedStyleFile = try! Generator.createFileURL(fileName: Generator.Constants.stylesFileName, outputDirectory: outputDirectory)
            
            let _ = try? FileManager.default.removeItem(at: generatedColorFile)
            let _ = try? FileManager.default.removeItem(at: generatedStyleFile)
            
            try Generator.generate(colors: colors, styles: styles, outputDirectory: outputDirectory, jsonHash: jsonHash)
            
            do {
                let generatedColorSwift = try String(contentsOf: generatedColorFile)
                let generatedStyleSwift = try String(contentsOf: generatedStyleFile)
                
                let expectedColorURL = Bundle(for: NamedColorSetGeneratorTests.self).urlForResource("ColorSet+FlairParser", withExtension: "swift.output")!
                let expectedStyleURL = Bundle(for: NamedColorSetGeneratorTests.self).urlForResource("Style+FlairParser", withExtension: "swift.output")!
                
                let expectedColorSwift = try! String(contentsOf: expectedColorURL)
                let expectedStyleSwift = try! String(contentsOf: expectedStyleURL)
                
                XCTAssert(generatedColorSwift == expectedColorSwift, "Generated color code doesn't match the expected")
                XCTAssert(generatedStyleSwift == expectedStyleSwift, "Generated style code doesn't match the expected")
            } catch let error as Generator.Error {
                XCTAssert(false, "Failed with error \(error.legacyError)")
            } catch {
                XCTAssert(false, "Unknown error")
            }
            
            let _ = try? FileManager.default.removeItem(at: generatedColorFile)
            let _ = try? FileManager.default.removeItem(at: generatedStyleFile)
            
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

//
//  NamedColorSetGeneratorTests.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/27/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair
@testable import FlairParserFramework

class NamedColorSetGeneratorTests: XCTestCase {

    func testColorGeneration() {
        let json = Bundle(for: ParserTests.self).urlForResource("validColorAndStyle", withExtension: "json")!
        
        do {
            let parser = try Parser(json: json)
            let (colors, styles, jsonHash) = try parser.parse()
            XCTAssert(colors.count == 2, "Invalid # of colors")
            XCTAssert(styles.count == 2, "Invalid # of styles")
            XCTAssert(jsonHash.characters.count > 0, "Invalid hash")
            
            let hashComment = Generator.jsonHashComment(jsonHash: jsonHash)
            
            let generatedSwift = NamedColorSetGenerator.generate(colors: colors, headerComment: hashComment)
            
            let expectedURL = Bundle(for: NamedColorSetGeneratorTests.self).urlForResource("ColorSet+FlairParser", withExtension: "swift.output")!
            let expectedSwift = try! String(contentsOf: expectedURL)
            
            XCTAssert(generatedSwift == expectedSwift, "Generated code doesn't match the expected")
            
        } catch let error as Parser.Error {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

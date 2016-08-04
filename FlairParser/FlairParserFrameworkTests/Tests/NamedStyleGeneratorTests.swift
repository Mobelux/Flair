//
//  NamedStyleGeneratorTests.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/27/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import XCTest
import Flair
@testable import FlairParserFramework

class NamedStyleGeneratorTests: XCTestCase {
    
    func testStyleGeneration() {
        let json = Bundle(for: ParserTests.self).url(forResource:"validColorAndStyle", withExtension: "json")!
        
        do {
            let parser = try Parser(json: json)
            let (colors, styles, jsonHash) = try parser.parse()
            XCTAssert(colors.count == 2, "Invalid # of colors")
            XCTAssert(styles.count == 2, "Invalid # of styles")
            XCTAssert(jsonHash.characters.count > 0, "Invalid hash")
            
            let hashComment = Generator.jsonHashComment(jsonHash: jsonHash)
            
            let generatedSwift = NamedStyleGenerator.generate(styles: styles, headerComment: hashComment)
            
            let expectedURL = Bundle(for: NamedStyleGeneratorTests.self).url(forResource: "Style+FlairParser", withExtension: "swift.output")!
            let expectedSwift = try! String(contentsOf: expectedURL)
            
            XCTAssert(generatedSwift == expectedSwift, "Generated code doesn't match the expected")
            
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

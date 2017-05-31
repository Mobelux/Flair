//
//  NamedColorSetGeneratorTests.swift
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

class NamedColorSetGeneratorTests: XCTestCase {

    func testColorGeneration() {
        let json = Bundle(for: ParserTests.self).url(forResource: "validColorAndStyle", withExtension: "json")!
        
        do {
            let parser = try Parser(json: json)
            let (colors, styles) = try parser.parse()
            XCTAssert(colors.count == 2, "Invalid # of colors")
            XCTAssert(styles.count == 2, "Invalid # of styles")

            let generatedSwift = NamedColorSetGenerator.generate(colors: colors)
            
            let expectedURL = Bundle(for: NamedColorSetGeneratorTests.self).url(forResource: "ColorSet+FlairParser", withExtension: "swift.output")!
            let expectedSwift = try! String(contentsOf: expectedURL)
            
            XCTAssert(generatedSwift == expectedSwift, "Generated code doesn't match the expected")
            
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

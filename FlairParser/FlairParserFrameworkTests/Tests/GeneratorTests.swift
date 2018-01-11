//
//  GeneratorTests.swift
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

class GeneratorTests: XCTestCase {

    func testColorAndStyleGeneration() {
        let json = Bundle(for: ParserTests.self).url(forResource: "validColorAndStyle", withExtension: "json")!
        
        do {
            let parser = try Parser(json: json)
            let (colors, styles) = try parser.parse()
            XCTAssert(colors.count == 2, "Invalid # of colors")
            XCTAssert(styles.count == 2, "Invalid # of styles")
            
            let outputDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
            let generatedColorFile = try! FlairGenerator.createFileURL(fileName: FlairGenerator.Constants.colorsFileName, outputDirectory: outputDirectory)
            let generatedStyleFile = try! FlairGenerator.createFileURL(fileName: FlairGenerator.Constants.stylesFileName, outputDirectory: outputDirectory)
            
            let _ = try? FileManager.default.removeItem(at: generatedColorFile)
            let _ = try? FileManager.default.removeItem(at: generatedStyleFile)
            
            try FlairGenerator.generate(colors: colors, styles: styles, outputDirectory: outputDirectory)
            
            do {
                let generatedColorSwift = try String(contentsOf: generatedColorFile)
                let generatedStyleSwift = try String(contentsOf: generatedStyleFile)
                
                let expectedColorURL = Bundle(for: NamedColorSetGeneratorTests.self).url(forResource: "ColorSet+FlairParser", withExtension: "swift.output")!
                let expectedStyleURL = Bundle(for: NamedColorSetGeneratorTests.self).url(forResource: "Style+FlairParser", withExtension: "swift.output")!
                
                let expectedColorSwift = try! String(contentsOf: expectedColorURL)
                let expectedStyleSwift = try! String(contentsOf: expectedStyleURL)
                
                XCTAssert(generatedColorSwift == expectedColorSwift, "Generated color code doesn't match the expected")
                XCTAssert(generatedStyleSwift == expectedStyleSwift, "Generated style code doesn't match the expected")
            } catch let error as FlairGenerator.GeneratorError {
                XCTAssert(false, "Failed with error \(error.legacyError)")
            } catch {
                XCTAssert(false, "Unknown error")
            }
            
            let _ = try? FileManager.default.removeItem(at: generatedColorFile)
            let _ = try? FileManager.default.removeItem(at: generatedStyleFile)
            
        } catch let error as Parser.ParserError {
            XCTAssert(false, "Failed with error \(error.legacyError)")
        } catch {
            XCTAssert(false, "Unknown error")
        }
    }
}

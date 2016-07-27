//
//  LegacyParserGenerator.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/22/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

@objc public class LegacyParserGenerator: NSObject {
    @objc public static func parse(json: URL, outputDirectory: URL) -> NSError? {
        let parseResult = parse(json: json)
        
        switch parseResult {
        case .error(let error):
            return error
        case .result(let colors, let styles, let jsonHash):
            return generate(colors: colors, styles: styles, jsonHash: jsonHash, outputDirectory: outputDirectory)
        }
    }
    
    private enum ParseResult {
        case error(error: NSError)
        case result(colors: [NamedColorSet], styles: [NamedStyle], jsonHash: String)
    }
    
    private static func parse(json: URL) -> ParseResult {
        do {
            let parser = try Parser(json: json)
            let (colors, styles, jsonHash) = try parser.parse()
            return .result(colors: colors, styles: styles, jsonHash: jsonHash)
        } catch let error as Parser.Error {
            return .error(error: error.legacyError)
        } catch {
            return .error(error: Parser.Error.unknown.legacyError)
        }
    }
    
    private static func generate(colors: [NamedColorSet], styles: [NamedStyle], jsonHash: String, outputDirectory: URL) -> NSError? {
        do {
            try Generator.generate(colors: colors, styles: styles, outputDirectory: outputDirectory, jsonHash: jsonHash)
            return nil
        } catch let error as Generator.Error {
            return error.legacyError
        } catch {
            return Generator.Error.unknown.legacyError
        }
    }
}

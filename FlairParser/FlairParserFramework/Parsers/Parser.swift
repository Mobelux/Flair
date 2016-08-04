//
//  Parser.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/22/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation
import Flair

public struct Parser {

    public enum ParserError: Int, Error {
        case unknown = 10
        case cantOpenJSONFile = 11
        case unreadableJSONSyntax = 12
        case noColorsOrStyles = 13
        case missingColorDict = 14
        case missingStyleDict = 15
        case invalidColorValue = 16
        case missingStandardColor = 17
        case invalidFontValue = 18
        case missingFontDict = 19
        
        static let domain = "com.mobelux.flair.parser"
        
        var legacyError: NSError {
            let message: String = {
                switch self {
                case .cantOpenJSONFile:
                    return "Unable to open JSON file for parsing"
                case .unknown:
                    return "Unknown error"
                case .unreadableJSONSyntax:
                    return "The JSON file has a syntax error that prevents parsing"
                case .noColorsOrStyles:
                    return "The JSON does not contain any colors or styles"
                case .missingColorDict:
                    return "The JSON is missing the color dictionary"
                case .missingStyleDict:
                    return "The JSON is missing the style dictionary"
                case .invalidColorValue:
                    return "The color value is not in the format: rgba(0.0, 1.1, 0.25, 1.0)"
                case .missingStandardColor:
                    return "A ColorSet is missing it's required standard color"
                case .invalidFontValue:
                    return "A Font value is not correct"
                case .missingFontDict:
                    return "A Style is missing it's Font key/value"
                }
            }()
            return NSError(domain: ParserError.domain, code: rawValue, userInfo: [NSLocalizedDescriptionKey : message])
        }
    }
    
    private let json: JSON
    
    public init(json: URL) throws {
        let data: Data = try {
            do {
                return try Data(contentsOf: json)
            } catch {
                throw ParserError.cantOpenJSONFile
            }
        }()

        do {
            guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
                throw ParserError.unreadableJSONSyntax
            }
            
            self.json = jsonDict
        } catch {
            throw ParserError.unreadableJSONSyntax
        }
    }
    
    public init(json: JSON) {
        self.json = json
    }
    
    public func parse() throws -> (colors: [NamedColorSet], styles: [NamedStyle], jsonHash: String) {
        let colors = try ColorParser.parse(json: json)
        let styles = try StyleParser.parse(json: json, namedColors: colors)
        
        guard colors.count > 0 || styles.count > 0 else { throw ParserError.noColorsOrStyles }
        
        let hash = try json.hash()
        return (colors: colors, styles: styles, jsonHash: hash)
    }
}

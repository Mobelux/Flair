//
//  Generator.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/26/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation
import Flair

public enum Generator {
    public enum Error: Int, ErrorProtocol {
        case unknown = 10
        case cantWriteSwiftFile = 11
        case noColorsOrStyles = 12
        case cantConvertSwiftStringToData = 13
        
        static let domain = "com.mobelux.flair.generator"
        
        var legacyError: NSError {
            let message: String = {
                switch self {
                case .cantWriteSwiftFile:
                    return "Unable to write Swift file"
                case .unknown:
                    return "Unknown error"
                case .noColorsOrStyles:
                    return "There are no colors or styles to write"
                case .cantConvertSwiftStringToData:
                    return "There was a problem converting the generated Swift string to data"
                }
            }()
            return NSError(domain: Error.domain, code: rawValue, userInfo: [NSLocalizedDescriptionKey : message])
        }
    }
    
    /// Internal so we can test
    enum Constants {
        static let colorsFileName = "ColorSet+FlairParser.swift"
        static let stylesFileName = "Style+FlairParser.swift"
        static let hashComment = "// hash:"
        static let hashCommentMessage = "\n// Do not modify this file. The previous line is a hash of the JSON used to generate this file. This file will not be regenerated unless the JSON changes, or this comment is removed."
    }
    
    public static func generate(colors: [NamedColorSet], styles: [NamedStyle], outputDirectory: URL, jsonHash: String) throws {
        guard colors.count > 0 || styles.count > 0 else { throw Error.noColorsOrStyles }
        
        let colorsFileURL = try createFileURL(fileName: Constants.colorsFileName, outputDirectory: outputDirectory)
        let stylesFileURL = try createFileURL(fileName: Constants.stylesFileName, outputDirectory: outputDirectory)
        
        let hashComment = jsonHashComment(jsonHash: jsonHash)
        
        if doesSwiftNeedGeneration(swiftFile: colorsFileURL, jsonHashComment: hashComment) {
            let colorsSwift = NamedColorSetGenerator.generate(colors: colors, headerComment: hashComment)
            
            let colorsSwiftData = try colorsSwift.utf8Data()
            try colorsSwiftData.writeData(to: colorsFileURL)
        }
        
        if doesSwiftNeedGeneration(swiftFile: stylesFileURL, jsonHashComment: hashComment) {
            // TODO
        }
        
    }
    
    /// Internal so we can test
    static func jsonHashComment(jsonHash: String) -> String {
        let hashComment = "\(Constants.hashComment) \(jsonHash)"
        return hashComment + Constants.hashCommentMessage
    }
    
    /// Internal so we can test
    static func createFileURL(fileName: String, outputDirectory: URL) throws -> URL {
        do {
            let fileURL = try outputDirectory.appendingPathComponent(fileName)
            return fileURL
        } catch {
            throw Error.unknown
        }
    }
    
    private static func doesSwiftNeedGeneration(swiftFile: URL, jsonHashComment: String) -> Bool {
        do {
            let swift = try String(contentsOf: swiftFile)
            return !swift.hasPrefix(jsonHashComment)
        } catch {
            return true
        }
    }
}

private extension String {
    func utf8Data() throws -> Data {
        guard let data = self.data(using: .utf8) else { throw Generator.Error.cantConvertSwiftStringToData }
        return data
    }
}

private extension Data {
    func writeData(to url: URL) throws {
        let _ = try? FileManager.default.removeItem(at: url)
        
        do {
            try write(to: url)
        } catch {
            throw FlairParserFramework.Generator.Error.cantWriteSwiftFile
        }
    }
}

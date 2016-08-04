//
//  Generator.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/26/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation
import Flair

/// Object that handles creating Swift code for ColorSets & Styles, and writing them to disk.
public enum Generator {
    public enum GeneratorError: Int, Error {
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
            return NSError(domain: GeneratorError.domain, code: rawValue, userInfo: [NSLocalizedDescriptionKey : message])
        }
    }
    
    /// Internal so we can test
    enum Constants {
        static let colorsFileName = "ColorSet+FlairParser.swift"
        static let stylesFileName = "Style+FlairParser.swift"
        static let hashComment = "// hash:"
        static let hashCommentMessage = "\n// Do not modify this file. The previous line is a hash of the JSON used to generate this file. This file will not be regenerated unless the JSON changes, or this comment is removed."
    }
    
    /**
        Generates Swift extensions on `ColorSet` and `Style` to add static accessors for specific colors & styles. The Swift files will only be regenerated if the `jsonHash` is different from the hash that the existing files have (if they exist).`jsonHash`. Throws `Generator.Error` errors.

        - parameter colors:             The colors that we want to create Swift for. If both `colors` and `styles` is 0 then throws `Generator.Error.noColorsOrStyles`
        - parameter styles:             The styles that we want to creat Swift for. If both `colors` and `styles` is 0 then throws `Generator.Error.noColorsOrStyles`
        - parameter outputDirectory:    The directory where we should write/overwrite the Swift extensions. The extension's file names will be in the pattern `<ColorSet/Style>+FlairParser.swift`
        - parameter jsonHash:           The hash of the JSON that was used to generate these `colors` & `styles` so we can be smart about not regenerating the Swift files, if there are no changes since last generation
    */
    public static func generate(colors: [NamedColorSet], styles: [NamedStyle], outputDirectory: URL, jsonHash: String) throws {
        guard colors.count > 0 || styles.count > 0 else { throw GeneratorError.noColorsOrStyles }
        
        let colorsFileURL = try createFileURL(fileName: Constants.colorsFileName, outputDirectory: outputDirectory)
        let stylesFileURL = try createFileURL(fileName: Constants.stylesFileName, outputDirectory: outputDirectory)
        
        let hashComment = jsonHashComment(jsonHash: jsonHash)
        
        if doesSwiftNeedGeneration(swiftFile: colorsFileURL, jsonHashComment: hashComment) {
            let colorsSwift = NamedColorSetGenerator.generate(colors: colors, headerComment: hashComment)
            
            let colorsSwiftData = try colorsSwift.utf8Data()
            try colorsSwiftData.writeData(to: colorsFileURL)
        }
        
        if doesSwiftNeedGeneration(swiftFile: stylesFileURL, jsonHashComment: hashComment) {
            let stylesSwift = NamedStyleGenerator.generate(styles: styles, headerComment: hashComment)
            
            let stylesSwiftData = try stylesSwift.utf8Data()
            try stylesSwiftData.writeData(to: stylesFileURL)
        }
    }
    
    /// Internal so we can test
    static func jsonHashComment(jsonHash: String) -> String {
        let hashComment = "\(Constants.hashComment) \(jsonHash)"
        return hashComment + Constants.hashCommentMessage
    }
    
    /// Internal so we can test
    static func createFileURL(fileName: String, outputDirectory: URL) throws -> URL {
        let fileURL = outputDirectory.appendingPathComponent(fileName)
        return fileURL
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
        guard let data = self.data(using: .utf8) else { throw Generator.GeneratorError.cantConvertSwiftStringToData }
        return data
    }
}

private extension Data {
    func writeData(to url: URL) throws {
        let _ = try? FileManager.default.removeItem(at: url)
        
        do {
            try write(to: url)
        } catch {
            throw FlairParserFramework.Generator.GeneratorError.cantWriteSwiftFile
        }
    }
}

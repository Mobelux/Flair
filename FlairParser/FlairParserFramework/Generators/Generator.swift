//
//  Generator.swift
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

import Foundation
import Flair

/// Object that handles creating Swift code for ColorSets & Styles, and writing them to disk.
public enum FlairGenerator {
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
    }
    
    /**
        Generates Swift extensions on `ColorSet` and `Style` to add static accessors for specific colors & styles. Throws `Generator.Error` errors.

        - parameter colors:             The colors that we want to create Swift for. If both `colors` and `styles` is 0 then throws `Generator.Error.noColorsOrStyles`
        - parameter styles:             The styles that we want to creat Swift for. If both `colors` and `styles` is 0 then throws `Generator.Error.noColorsOrStyles`
        - parameter outputDirectory:    The directory where we should write/overwrite the Swift extensions. The extension's file names will be in the pattern `<ColorSet/Style>+FlairParser.swift`
    */
    public static func generate(colors: [NamedColorSet], styles: [NamedStyle], outputDirectory: URL) throws {
        guard colors.count > 0 || styles.count > 0 else { throw GeneratorError.noColorsOrStyles }
        
        let colorsFileURL = try createFileURL(fileName: Constants.colorsFileName, outputDirectory: outputDirectory)
        let stylesFileURL = try createFileURL(fileName: Constants.stylesFileName, outputDirectory: outputDirectory)

        let colorsSwift = NamedColorSetGenerator.generate(colors: colors)
        if doesSwiftNeedSaving(to: colorsFileURL, swift: colorsSwift) {
            let colorsSwiftData = try colorsSwift.utf8Data()
            try colorsSwiftData.writeData(to: colorsFileURL)
        }

        let stylesSwift = NamedStyleGenerator.generate(styles: styles)
        if doesSwiftNeedSaving(to: stylesFileURL, swift: stylesSwift) {
            let stylesSwiftData = try stylesSwift.utf8Data()
            try stylesSwiftData.writeData(to: stylesFileURL)
        }
    }
    
    /// Internal so we can test
    static func createFileURL(fileName: String, outputDirectory: URL) throws -> URL {
        let fileURL = outputDirectory.appendingPathComponent(fileName)
        return fileURL
    }
    
    private static func doesSwiftNeedSaving(to swiftFile: URL, swift: String) -> Bool {
        do {
            let existingSwift = try String(contentsOf: swiftFile)
            return existingSwift != swift
        } catch {
            return true
        }
    }
}

private extension String {
    func utf8Data() throws -> Data {
		
		guard let data = self.data(using: .utf8) else { throw FlairGenerator.GeneratorError.cantConvertSwiftStringToData }
        return data
    }
}

private extension Data {
    func writeData(to url: URL) throws {
        let _ = try? FileManager.default.removeItem(at: url)
        
        do {
            try write(to: url)
        } catch {
            throw FlairParserFramework.FlairGenerator.GeneratorError.cantWriteSwiftFile
        }
    }
}

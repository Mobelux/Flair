//
//  NamedStyleGenerator.swift
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

/// Generates the Swift code for `NamedStyle` as an extension on `Style`
enum NamedStyleGenerator: ExtensionGenerator {
    private enum Constants {
        static let normal = "normal"
        static let highlighted = "highlighted"
        static let selected = "selected"
        static let disabled = "disabled"
    }
    
    /**
     Generates the Swift code for `NamedStyle` as an extension on `Style`
     
     - parameter styles:         The styles that we want in the extension. Ordering of this array is ignored, and generated styles will always be sorted by `style.name`
     
     - returns: The Swift source for this new extension on `Style`, ready to write to disk
     */
    static func generate(styles: [NamedStyle]) -> String {
        let sortedStyles = styles.sorted { $0.name < $1.name }
        let functions = sortedStyles.map({ generate(style: $0) })
        
        let swiftCode = generate(functions: functions, extending: "Style")
        return swiftCode
    }
    
    private static func generate(style: NamedStyle) -> String {
        let font = generate(font: style.font)
        let textColor = generateTextColor(for: style.textColor?.name)
        
        var returnLine = "        return Style(font: font"
        if style.kerning != 0 {
            returnLine.append(", kerning: \(style.kerning)")
        }
        if style.lineHeightMultiple != 0 {
            returnLine.append(", lineHeightMultiple: \(style.lineHeightMultiple)")
        }
        if let textColor = textColor {
            returnLine.append(", textColor: \(textColor)")
        }
        returnLine.append(")\n")
        
        var styleFunc = "    static var \(style.name): Style {\n"
        styleFunc.append(font)
        styleFunc.append(returnLine)
        styleFunc.append("    }\n\n")
        return styleFunc
    }
    
    private static func generate(font: Font) -> String {
        let type: String = {
            switch font.type {
            case .normal(let fontName):
                return ".normal(fontName: \"\(fontName)\")"
            case .system(let weight):
                return ".system(weight: .\(weight.rawValue))"
            }
        }()
        
        let sizeType: String = {
            switch font.sizeType {
            case .staticSize(let pointSize):
                return ".staticSize(pointSize: \(pointSize))"
            case .dynamicSize(let pointSizeBase):
                return ".dynamicSize(pointSizeBase: \(pointSizeBase))"
            }
        }()
        
        let fontString = "        let font = Font(type: \(type), sizeType: \(sizeType))\n"
        return fontString
    }
    
    private static func generateTextColor(for name: String?) -> String? {
        guard let name = name else { return nil }
        let textColor = "ColorSet.\(name)()"
        return textColor
    }
}

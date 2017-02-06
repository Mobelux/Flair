//
//  NamedStyleGenerator.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/27/16.
//  Copyright © 2016 Mobelux. All rights reserved.
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
        
        var styleFunc = "    static func \(style.name)() -> Style {\n"
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

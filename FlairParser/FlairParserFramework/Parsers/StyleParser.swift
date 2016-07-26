//
//  StyleParser.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

enum StyleParser {
    private enum Constants {
        static let stylesKey = "styles"
        static let fontKey = "font"
        static let lineSpacingKey = "lineSpacing"
        static let kerningKey = "kerning"
        static let textColorNameKey = "textColor"
    }
    
    static func parse(json: Parser.JSON, namedColors: [NamedColorSet]) throws -> [NamedStyle] {
        guard let styleDict = json[Constants.stylesKey] as? Parser.JSON else { throw Parser.Error.missingStyleDict }
        
        var styles: [NamedStyle] = []
        for styleKey in styleDict.keys {
            if let styleName = styleKey as? String, let value = styleDict[styleName] as? Parser.JSON {
                let style = try NamedStyle(name: styleName, styleValues: value, colors: namedColors)
                styles.append(style)
            }
        }
        
        return styles
    }
}

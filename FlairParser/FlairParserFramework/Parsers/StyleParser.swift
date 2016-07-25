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
        
    }
    
    static func parse(json: Parser.JSON, namedColors: [NamedColorSet]) throws -> [NamedStyle] {
        guard let styleDict = json[Constants.stylesKey] as? Parser.JSON else { throw Parser.Error.missingStyleDict }
        
        var styles: [NamedStyle] = []
        for styleName in styleDict.keys {
            if let value = styleDict[styleName] as? Parser.JSON {
                
            }
        }
        
        return styles
    }
}

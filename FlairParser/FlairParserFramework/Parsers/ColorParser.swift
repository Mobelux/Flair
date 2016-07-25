//
//  ColorParser.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation
import Flair

enum ColorParser {
    private enum Constants {
        static let colorsKey = "colors"
    }
    
    static func parse(json: Parser.JSON) throws -> [NamedColorSet] {
        guard let colorDict = json[Constants.colorsKey] as? Parser.JSON else { throw Parser.Error.missingColorDict }
    
        var colors: [NamedColorSet] = []
        colors.reserveCapacity(colorDict.count)
        
        for colorKey in colorDict.keys {
            if let colorName = colorKey as? String, let colorValueDict = colorDict[colorName] as? Parser.JSON {
                let colorSet = try ColorSet(colorValues: colorValueDict)
                let namedColorSet = NamedColorSet(name: colorName, colorSet: colorSet)
                colors.append(namedColorSet)
            }
        }
        
        return colors
    }
}

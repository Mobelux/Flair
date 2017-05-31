//
//  ColorParser.swift
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

enum ColorParser {
    private enum Constants {
        static let colorsKey = "colors"
    }
    
    static func parse(json: JSON) throws -> [NamedColorSet] {
        guard let colorDict = json[Constants.colorsKey] as? JSON else { throw Parser.ParserError.missingColorDict }
    
        var colors: [NamedColorSet] = []
        colors.reserveCapacity(colorDict.count)
        
        for colorKey in colorDict.keys {
            if let colorValueDict = colorDict[colorKey] as? JSON {
                let namedColorSet = try NamedColorSet(name: colorKey, colorValues: colorValueDict)
                colors.append(namedColorSet)
            }
        }
        
        return colors
    }
}

//
//  Font+init.swift
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

extension Font {
    private enum Constants {
        static let fontSizeKey = "size"
        static let fontNameKey = "fontName"
        static let systemFontWeightKey = "systemFontWeight"
        static let sizeTypeKey = "sizeType"
        static let sizeTypeStatic = "static"
        static let sizeTypeDynamic = "dynamic"
    }
    
    init(fontValues: JSON) throws {
        guard let size = fontValues[Constants.fontSizeKey] as? CGFloat, let sizeType = fontValues[Constants.sizeTypeKey] as? String else { throw Parser.ParserError.invalidFontValue }
        
        if let fontName = fontValues[Constants.fontNameKey] as? String {
            type = .normal(fontName: fontName)
        } else if let weightString = fontValues[Constants.systemFontWeightKey] as? String, let weight = Font.Weight(rawValue: weightString) {
            type = .system(weight: weight)
        } else {
            throw Parser.ParserError.invalidFontValue
        }
            
        // These are required because of what seems like a compiler error. Using `Constants.sizeType<static/dynamic>` in the switch cases below causes the compiler to think it's an enum case
        let staticType = Constants.sizeTypeStatic
        let dynamic = Constants.sizeTypeDynamic

        switch sizeType {
        case staticType:
            self.sizeType = .staticSize(pointSize: size)
        case dynamic:
            self.sizeType = .dynamicSize(pointSizeBase: size)
        default:
            throw Parser.ParserError.invalidFontValue
        }
    }
}

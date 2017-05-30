//
//  NamedStyle+Init.swift
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

extension NamedStyle {
    private enum Constants {
        static let fontKey = "font"
        static let lineHeightMultipleKey = "lineHeightMultiple"
        static let kerningKey = "kerning"
        static let textColorKey = "textColor"
    }
    
    init(name: String, styleValues: JSON, colors: [NamedColorSet]) throws {
        self.name = name
        
        guard let fontValue = styleValues[Constants.fontKey] as? JSON else { throw Parser.ParserError.missingFontDict }
        font = try Font(fontValues: fontValue)
        
        if let lineHeightMultiple = styleValues[Constants.lineHeightMultipleKey] as? CGFloat {
            self.lineHeightMultiple = lineHeightMultiple
        } else {
            lineHeightMultiple = 0
        }
        
        if let kerning = styleValues[Constants.kerningKey] as? CGFloat {
            self.kerning = kerning
        } else {
            kerning = 0
        }
        
        if let textColorName = styleValues[Constants.textColorKey] as? String {
            self.textColor = colors.filter({ $0.name == textColorName }).first
        } else {
            textColor = nil
        }        
    }
}

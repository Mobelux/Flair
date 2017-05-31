//
//  NamedColorSet+Init.swift
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

extension NamedColorSet {
    private enum Constants {
        static let normalColorKey = "normal"
        static let highlightedColorKey = "highlighted"
        static let selectedColorKey = "selected"
        static let disabledColorKey = "disabled"
    }
    
    init(name: String, colorValues: JSON) throws {
        self.name = name
        
        guard let normalValue = colorValues[Constants.normalColorKey] as? String else { throw Parser.ParserError.missingStandardColor }
        normalColor = try Color(string: normalValue)
        
        if let highlightedValue = colorValues[Constants.highlightedColorKey] as? String {
            highlightedColor = try Color(string: highlightedValue)
        } else {
            highlightedColor = nil
        }
        
        if let selectedValue = colorValues[Constants.selectedColorKey] as? String {
            selectedColor = try Color(string: selectedValue)
        } else {
            selectedColor = nil
        }
        
        if let disabledValue = colorValues[Constants.disabledColorKey] as? String {
            disabledColor = try Color(string: disabledValue)
        } else {
            disabledColor = nil
        }
    }
}

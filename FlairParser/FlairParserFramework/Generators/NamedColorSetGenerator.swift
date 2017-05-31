//
//  NamedColorSetGenerator.swift
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

/// Generates the Swift code for `NamedColorSet` as an extension on `ColorSet`
enum NamedColorSetGenerator: ExtensionGenerator {
    private enum Constants {
        static let normal = "normal"
        static let highlighted = "highlighted"
        static let selected = "selected"
        static let disabled = "disabled"
    }
    
    /**
        Generates the Swift code for `NamedColorSet` as an extension on `ColorSet`
     
        - parameter colors:         The colors that we want in the extension. Ordering of this array is ignored, and generated colors will always be sorted by `color.name`
        
        - returns: The Swift source for this new extension on `ColorSet`, ready to write to disk
    */
    static func generate(colors: [NamedColorSet]) -> String {
        let sortedColors = colors.sorted { $0.name < $1.name }
        let functions = sortedColors.map({ generate(color: $0) })
        
        let swiftCode = generate(functions: functions, extending: "ColorSet")
        return swiftCode
    }
    
    private static func generate(color: NamedColorSet) -> String {
        let normal = generate(color: color.normalColor, name: Constants.normal)!
        let highlighted = generate(color: color.highlightedColor, name: Constants.highlighted)
        let selected = generate(color: color.selectedColor, name: Constants.selected)
        let disabled = generate(color: color.disabledColor, name: Constants.disabled)
        
        var returnLine = "        return ColorSet(normalColor: \(Constants.normal)"
        if highlighted != nil {
            returnLine.append(", highlightedColor: \(Constants.highlighted)")
        }
        if selected != nil {
            returnLine.append(", selectedColor: \(Constants.selected)")
        }
        if disabled != nil {
            returnLine.append(", disabledColor: \(Constants.disabled)")
        }
        returnLine.append(")\n")
        
        var colorFunc = "    static var \(color.name): ColorSet {\n"
        colorFunc.append(normal)
        if let highlighted = highlighted {
            colorFunc.append(highlighted)
        }
        if let selected = selected {
            colorFunc.append(selected)
        }
        if let disabled = disabled {
            colorFunc.append(disabled)
        }
        
        colorFunc.append(returnLine)
        colorFunc.append("    }\n\n")

        return colorFunc
    }
    
    private static func generate(color: Color?, name: String) -> String? {
        guard let color = color else { return nil }
        
        let colorString = "        let \(name) = Color(red: \(color.red), green: \(color.green), blue: \(color.blue), alpha: \(color.alpha))\n"
        return colorString
    }
}

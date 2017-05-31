//
//  Color+Init.swift
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

extension Color {
    private enum Constants {
        static let prefix = "rgba("
        static let suffix = ")"
    }
    
    init(string: String) throws {
        guard let prefixRange = string.range(of: Constants.prefix), let suffixRange = string.range(of: Constants.suffix) else { throw Parser.ParserError.invalidColorValue }
        
        let componentRange = prefixRange.upperBound ..< suffixRange.lowerBound
        let componentString = string.substring(with: componentRange)
        let componentArray = componentString.components(separatedBy: ",").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
        
        guard componentArray.count == 4 else { throw Parser.ParserError.invalidColorValue }
        
        guard let red = Double(componentArray[0]), let green = Double(componentArray[1]), let blue = Double(componentArray[2]), let alpha = Double(componentArray[3]) else { throw Parser.ParserError.invalidColorValue }
        
        self.red = CGFloat(red)
        self.green = CGFloat(green)
        self.blue = CGFloat(blue)
        self.alpha = CGFloat(alpha)
    }
}

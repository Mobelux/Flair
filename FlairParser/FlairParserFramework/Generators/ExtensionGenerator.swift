//
//  ExtensionGenerator.swift
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

/// Basic protocol for shared behavior between extension generators
protocol ExtensionGenerator {
    
    /**
     
        - parameter functions:      An array of `Strings` where each string contains the entire function or variable code that should be added to an extension
        - parameter extending:      The name of the type to extend, so if you want `extension ColorSet` you should pass `ColorSet` to this param
    */
    static func generate(functions: [String], extending extendingType: String) -> String
}

extension ExtensionGenerator {
    static func generate(functions: [String], extending extendingType: String) -> String {
        var swiftCode = "import Flair\n\nextension \(extendingType) {\n"
        
        for function in functions {
            swiftCode.append(function)
        }
        
        swiftCode.append("}\n")
        return swiftCode
    }
}

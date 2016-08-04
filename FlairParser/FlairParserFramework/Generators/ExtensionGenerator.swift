//
//  ExtensionGenerator.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/27/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

/// Basic protocol for shared behavior between extension generators
protocol ExtensionGenerator {
    
    /**
     
        - parameter functions:      An array of `Strings` where each string contains the entire function or variable code that should be added to an extension
        - parameter extending:      The name of the type to extend, so if you want `extension ColorSet` you should pass `ColorSet` to this param
        - parameter headerComment:  The comment to place at the very beginning of the `String`. This comment should include the JSON hash, but that isn't required
    */
    static func generate(functions: [String], extending extendingType: String, headerComment: String) -> String
}

extension ExtensionGenerator {
    static func generate(functions: [String], extending extendingType: String, headerComment: String) -> String {
        var swiftCode = "\(headerComment)\n\nimport Flair\n\nextension \(extendingType) {\n"
        
        for function in functions {
            swiftCode.append(function)
        }
        
        swiftCode.append("}\n")
        return swiftCode
    }
}

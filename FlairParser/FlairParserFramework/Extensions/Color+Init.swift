//
//  Color+Init.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
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

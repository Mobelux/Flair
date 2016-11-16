//
//  NamedStyle+Init.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
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

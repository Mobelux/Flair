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
        static let lineSpacingKey = "lineSpacing"
        static let kerningKey = "kerning"
        static let textColorKey = "textColor"
    }
    
    init(name: String, styleValues: Parser.JSON, colors: [NamedColorSet]) throws {
        self.name = name
        
        guard let fontValue = styleValues[Constants.fontKey] as? Parser.JSON else { throw Parser.Error.missingFontDict }
        font = try Font(fontValues: fontValue)
        
        if let lineSpacing = styleValues[Constants.lineSpacingKey] as? CGFloat {
            self.lineSpacing = lineSpacing
        } else {
            lineSpacing = 0
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

//
//  Font+init.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
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
        guard let size = fontValues[Constants.fontSizeKey] as? CGFloat, let sizeType = fontValues[Constants.sizeTypeKey] as? String else { throw Parser.Error.invalidFontValue }
        
        if let fontName = fontValues[Constants.fontNameKey] as? String {
            type = .normal(fontName: fontName)
        } else if let weightString = fontValues[Constants.systemFontWeightKey] as? String, let weight = Font.Weight(rawValue: weightString) {
            type = .system(weight: weight)
        } else {
            throw Parser.Error.invalidFontValue
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
            throw Parser.Error.invalidFontValue
        }
    }
}

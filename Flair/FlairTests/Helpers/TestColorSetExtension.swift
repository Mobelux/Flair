//
//  TestColorSetExtension.swift
//  Flair
//
//  Created by Jerry Mayers on 11/17/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation
import Flair

extension ColorSet {
    static func someBlue() -> ColorSet {
        let normal = Color(red: 0.0, green: 0.0, blue: 0.75, alpha: 1.0)
        let highlighted = Color(red: 0.0, green: 0.0, blue: 0.6, alpha: 1.0)
        let selected = Color(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0)
        let disabled = Color(red: 0.0, green: 0.0, blue: 0.5, alpha: 0.5)
        return ColorSet(normalColor: normal, highlightedColor: highlighted, selectedColor: selected, disabledColor: disabled)
    }

    static func someBlue() -> PlatformColor {
        return someBlue().normalColor.color
    }

    static func someOrange() -> ColorSet {
        let normal = Color(red: 0.5, green: 0.25, blue: 0.75, alpha: 1.0)
        let highlighted = Color(red: 0.4, green: 0.15, blue: 0.6, alpha: 1.0)
        return ColorSet(normalColor: normal, highlightedColor: highlighted)
    }

    static func someOrange() -> PlatformColor {
        return someOrange().normalColor.color
    }
    
}

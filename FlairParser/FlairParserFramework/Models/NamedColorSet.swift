//
//  NamedColorSet.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation
import Flair

/// A `ColorSetType` that has a name you can set
public struct NamedColorSet: ColorSetType {
    public let name: String
    
    public let normalColor: Color
    public let highlightedColor: Color?
    public let selectedColor: Color?
    public let disabledColor: Color?
    
    public init(name: String, normalColor: Color, highlightedColor: Color? = nil, selectedColor: Color? = nil, disabledColor: Color? = nil) {
        self.name = name
        self.normalColor = normalColor
        self.highlightedColor = highlightedColor
        self.selectedColor = selectedColor
        self.disabledColor = disabledColor
    }
}

//
//  ColorSet.swift
//  Flair
//
//  Created by Jerry Mayers on 7/20/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

public struct ColorSet : ColorSetType {
    public let normalColor: Color
    public let highlightedColor: Color?
    public let selectedColor: Color?
    public let disabledColor: Color?
    public var color: PlatformColor { return normalColor.color }
    
    public init(normalColor: Color, highlightedColor: Color? = nil, selectedColor: Color? = nil, disabledColor: Color? = nil) {
        self.normalColor = normalColor
        self.highlightedColor = highlightedColor
        self.selectedColor = selectedColor
        self.disabledColor = disabledColor
    }
}

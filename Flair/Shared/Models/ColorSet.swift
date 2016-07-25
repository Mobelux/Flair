//
//  ColorSet.swift
//  Flair
//
//  Created by Jerry Mayers on 7/20/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

/**
 *  A set of colors that are related. These are named similar to `UIContolStates` since a common use case is to apply a `ColorSet` to a `UIControl` or similar to set the colors for all states at once.
 */
public struct ColorSet : Equatable {
    /// Typically used when `UIControlState.Normal` is used.
    public let normalColor: Color
    /// Typically used when `UIControlState.Highlighted` is used.
    public let highlightedColor: Color?
    /// Typically used when `UIControlState.Selected` is used.
    public let selectedColor: Color?
    /// Typically used when `UIControlState.Disabled` is used.
    public let disabledColor: Color?
    
    public init(normalColor: Color, highlightedColor: Color? = nil, selectedColor: Color? = nil, disabledColor: Color? = nil) {
        self.normalColor = normalColor
        self.highlightedColor = highlightedColor
        self.selectedColor = selectedColor
        self.disabledColor = disabledColor
    }
}

public func ==(lhs: ColorSet, rhs: ColorSet) -> Bool {
    return lhs.normalColor == rhs.normalColor && lhs.highlightedColor == rhs.highlightedColor && lhs.selectedColor == rhs.selectedColor && lhs.disabledColor == rhs.disabledColor
}

//
//  ColorSetType.swift
//  Flair
//
//  Created by Jerry Mayers on 7/25/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

/**
 *  A set of colors that are related. These are named similar to `UIContolStates` since a common use case is to apply a `ColorSet` to a `UIControl` or similar to set the colors for all states at once.
 */
public protocol ColorSetType : Equatable {
    /// Typically used when `UIControlState.Normal` is used.
    var normalColor: Color { get }
    /// Typically used when `UIControlState.Highlighted` is used.
    var highlightedColor: Color? { get }
    /// Typically used when `UIControlState.Selected` is used.
    var selectedColor: Color? { get }
    /// Typically used when `UIControlState.Disabled` is used.
    var disabledColor: Color? { get }
}

public func ==<T: ColorSetType>(lhs: T, rhs: T) -> Bool {
    return lhs.normalColor == rhs.normalColor && lhs.highlightedColor == rhs.highlightedColor && lhs.selectedColor == rhs.selectedColor && lhs.disabledColor == rhs.disabledColor
}

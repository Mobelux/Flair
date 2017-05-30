//
//  ColorSetType.swift
//  Flair
//
//  MIT License
//
//  Copyright (c) 2017 Mobelux
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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

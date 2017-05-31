//
//  TestColorSetExtension.swift
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
//  THE SOFTWARE.//

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

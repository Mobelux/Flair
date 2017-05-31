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

import UIKit
import Flair


var str = "Hello, playground"

let font = Font(systemFontWeight: .medium, sizeType: .dynamic(pointSizeBase: 12))
let colorSet = ColorSet(normalColor: Color(color: .red())!)
let basicStyle = Style(font: font, kerning: 0, lineSpacing: 0, textColor: colorSet)
let style = Style(font: font, kerning: 6, lineSpacing: 30, textColor: colorSet)
style.isBasicStyle
basicStyle.isBasicStyle

let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
label.backgroundColor = .white()

label.text = str
label.style = style
label.setStyled(text: "Hello world")




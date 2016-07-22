//: Playground - noun: a place where people can play

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




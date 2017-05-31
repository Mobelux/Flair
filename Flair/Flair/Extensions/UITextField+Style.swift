//
//  UITextField+Style.swift
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

#if os(iOS) || os(tvOS)
    import UIKit

    public extension UITextField {

        private static var styleKey: NSString = "styleKey"

        /// A `Style` that should be applied to the text in this field. If the `Style's font's sizeType == .dynamic` then this field will automatically update it's text when the user changes text size.
        public var style: Style? {
            get {
                let key = UITextField.styleKey.getVoidPointer()
                let styleBox = objc_getAssociatedObject(self, key) as? Box<Style>
                return styleBox?.object
            }
            set {
                let key = UITextField.styleKey.getVoidPointer()
                let styleBox: Box<Style>? = {
                    if let style = newValue {
                        return Box.init(object: style)
                    } else {
                        return nil
                    }
                }()
                objc_setAssociatedObject(self, key, styleBox, .OBJC_ASSOCIATION_RETAIN)

                updateStyle(newValue)
            }
        }

        private func registerForNotifications() {
            unregisterForNotifications()

            let noteCenter = NotificationCenter.default
            let selector = #selector(textSizeDidChangeNotification(notification:))
            noteCenter.addObserver(self, selector: selector, name: .UIContentSizeCategoryDidChange, object: nil)
            noteCenter.addObserver(self, selector: selector, name: .UIApplicationDidBecomeActive, object: nil)
        }

        private func unregisterForNotifications() {
            let noteCenter = NotificationCenter.default
            noteCenter.removeObserver(self, name: .UIContentSizeCategoryDidChange, object: nil)
            noteCenter.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
        }

        @objc private func textSizeDidChangeNotification(notification: Notification) {
            updateStyle(self.style)
        }

        private func updateStyle(_ style: Style?) {
            guard let style = style else {
                defaultTextAttributes = [:]
                font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
                textColor = UIColor.black
                unregisterForNotifications()
                return
            }

            switch style.font.sizeType {
            case .dynamicSize:
                registerForNotifications()
            case .staticSize:
                unregisterForNotifications()
            }

            if style.isBasicStyle {
                if let font = style.font.font {
                    self.font = font
                }
                if let textColor = style.textColor {
                    self.textColor = textColor.normalColor.color
                }
            } else {
                defaultTextAttributes = style.textAttributes(alignment: textAlignment, lineBreakMode: .byTruncatingTail)
            }
        }
    }

#endif

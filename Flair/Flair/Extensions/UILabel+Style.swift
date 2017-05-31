//
//  UILabel+Style.swift
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
  
    public extension UILabel {
        
        private static var styleKey: NSString = "styleKey"
        
        /// A `Style` that should be applied to the text in this label. After you set this `Style` you should then use `setStyled(text:)` instead of `text = newValue`. That way any new text will appear properly styled. You can still get the currently displayed text from the label using the `text` property. If the `Style's font's sizeType == .dynamic` then this label will automatically update it's text when the user changes text size.
        public var style: Style? {
            get {
                let key = UILabel.styleKey.getVoidPointer()
                let styleBox = objc_getAssociatedObject(self, key) as? Box<Style>
                return styleBox?.object
            }
            set {
                let key = UILabel.styleKey.getVoidPointer()
                let styleBox: Box<Style>? = {
                    if let style = newValue {
                        return Box.init(object: style)
                    } else {
                        return nil
                    }
                }()
                objc_setAssociatedObject(self, key, styleBox, .OBJC_ASSOCIATION_RETAIN)
                
                guard let style = newValue else {
                    font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
                    textColor = UIColor.black
                    let text = self.text
                    attributedText = nil
                    self.text = text
                    unregisterForNotifications()
                    return
                }
                
                switch style.font.sizeType {
                case .dynamicSize:
                    registerForNotifications()
                case .staticSize:
                    unregisterForNotifications()
                }
                
                setStyled(text: text)
            }
        }
        
        /**
            Sets some text to be displayed on this label.
         
            This behaves just like `label.text = newText` if the label's `style == nil`, otherwise it will ensure that the `text` you pass in is displayed with full styling
         
            - parameter text:   The text to display in this label, just like the system `text` property
        */
        public func setStyled(text: String?) {
            self.text = text
            
            guard let style = style else { return }
            
            if style.isBasicStyle {
                if let font = style.font.font {
                    self.font = font
                }
                if let textColor = style.textColor {
                    self.textColor = textColor.normalColor.color
                }
            } else {
                let textToSet = text ?? ""
                attributedText = textToSet.attributedString(for: style, alignment: textAlignment, lineBreakMode: lineBreakMode)
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
            if style == nil {
                unregisterForNotifications()
            } else {
                setStyled(text: text)
            }
        }
    }

#endif

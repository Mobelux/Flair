//
//  UILabel+Style.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
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
                attributedText = textToSet.attributedString(for: style, alignment: textAlignment, lineBreakMode: lineBreakMode, multiline: numberOfLines != 1)
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

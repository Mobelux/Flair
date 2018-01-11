//
//  UIButton+Style.swift
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

    public extension UIButton {

        /// A `Style` that should be applied to the title text in this button. After you set this `Style`, you should then use `setStyled(title:for:)` instead of `setTitle(for:)` to set the text to be displayed. You can still get the currently displayed text from the button using the normal means. If this `Style` has a non-nil `textColor` then that will be used instead of `setTitle(colorSet:)`.
        public var style: Style? {
            get {
                return titleLabel?.style
            }
            set {
                titleLabel?.style = newValue

                if let textColor = newValue?.textColor {
                    setTitle(colorSet: textColor)
                }

                if let style = newValue {
                    switch style.font.sizeType {
                    case .dynamicSize:
                        registerForNotifications()
                    case .staticSize:
                        unregisterForNotifications()
                    }
                } else {
                    unregisterForNotifications()
                }

                updateTitlesForStyleChange()
            }
        }

        /// Sets a title to be displayed for all control states. Similar to calling `setTitle(for:)` for each control state, but it will use the formatting from `Style`.
        /// This behaves exactly like `setTitle(for:)` if the `style` property is `nil`
        ///
        /// - Parameter newTitle: The text to display
        public func setStyled(title newTitle: String?) {
            setStyled(title: newTitle, for: .normal)
            setStyled(title: newTitle, for: .highlighted)
            setStyled(title: newTitle, for: .selected)
            setStyled(title: newTitle, for: .disabled)
        }

        /// Sets a title to be displayed for the state. Similar to `setTitle(for:)` but it will preserve the formatting you expect for the `Style`.

        /// This behaves exactly like `setTitle(for:)` if the `style` property is `nil`
        ///
        /// - Parameters:
        ///   - title: The text to display
        ///   - state: The state when this title should be displayed
        public func setStyled(title newTitle: String?, for state: UIControlState) {
            guard let style = style, let title = newTitle, !style.isBasicStyle else {
                setBasicStyle(self.style, title: newTitle, for: state)
                return
            }

            let alignment = titleLabel?.textAlignment ?? .center
            let lineBreakMode = titleLabel?.lineBreakMode ?? .byTruncatingMiddle
            var attributes = style.textAttributes(alignment: alignment, lineBreakMode: lineBreakMode)

            if let textColor = style.textColor {
                setTitle(colorSet: textColor)
            }
            if let textColor = titleColor(for: state) {
                attributes[NSAttributedStringKey.foregroundColor] = textColor
            }

            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            setAttributedTitle(attributedTitle, for: state)

        }

        private func setBasicStyle(_ basicStyle: Style?, title: String?, for state: UIControlState) {
            if let font = basicStyle?.font.font {
                titleLabel?.font = font
            }

            setTitle(title, for: state)
        }

        private func updateTitlesForStyleChange() {
            let normalTitle = title(for: .normal)
            let highlightedTitle = title(for: .highlighted)
            let selectedTitle = title(for: .selected)
            let disabledTitle = title(for: .disabled)

            setStyled(title: normalTitle, for: .normal)
            setStyled(title: highlightedTitle, for: .highlighted)
            setStyled(title: selectedTitle, for: .selected)
            setStyled(title: disabledTitle, for: .disabled)
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
                updateTitlesForStyleChange()
            }
        }
    }
#endif

//
//  UITextView+Style.swift
//  Flair
//
//  Created by David Martin on 12/18/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
	import UIKit
	
	public extension UITextView {
		
		private static var styleKey: NSString = "styleKey"
		
		/// A `Style` that should be applied to the text in this view. If the `Style's font's sizeType == .dynamic` then this view will automatically update it's text when the user changes text size.
		public var style: Style? {
			get {
				let key = UITextView.styleKey.getVoidPointer()
				let styleBox = objc_getAssociatedObject(self, key) as? Box<Style>
				return styleBox?.object
			}
			set {
				let key = UITextView.styleKey.getVoidPointer()
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
				typingAttributes = [:]
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
				typingAttributes = style.textAttributes(alignment: textAlignment, lineBreakMode: .byTruncatingTail)
			}
		}
	}
	
#endif

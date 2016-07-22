//
//  UIButton+BackgroundColor.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    
    // This extension adds the ability to set background `UIColors` for different `UIControlStates` similar to how a `UIButton` allows you to set different background `UIImages` for the different `UIControlStates`.
    public extension UIButton {
        /**
         Sets a particular color to be shown for a specific `state` of the button. The behavior matches `setBackgroundImage(forState)'s`.
         
         - parameter color: The color for the background. Passing `nil` clears out the color for a state.
         - parameter state: The control state when the `color` should be shown as the `backgroundColor`
         */
        public func setBackgroundColor(color: UIColor?, for state: UIControlState) {
            guard let key = key(for: state) else { return }
            objc_setAssociatedObject(self, key, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            let image: UIImage? = {
                if let color = color {
                    let size = CGSize(width: 1, height: 1)
                    return UIImage.image(of: color, size: size)
                } else {
                    return nil
                }
            }()
            setBackgroundImage(image, for: state)
        }
        
        /**
         Gets the background color that was set for a particular state using `setBackgroundColor()`
         
         - parameter state: The control state that you want the color for.
         
         - returns: The color used for the background if one was set for this state.
         */
        public func backgroundColor(for state: UIControlState) -> UIColor? {
            guard let key = key(for: state) else { return nil }
            let color = objc_getAssociatedObject(self, key) as? UIColor
            return color
        }
        
        
        // MARK: - Private
        
        private struct AssociationKeys {
            static var normal: NSString = "normal"
            static var highlighted: NSString = "highlighted"
            static var selected: NSString = "selected"
            static var disabled: NSString = "disabled"
            static var focused: NSString = "focused"
            static var application: NSString = "application"
            static var reserved: NSString = "reserved"
        }
        
        private func key(for state: UIControlState) -> UnsafePointer<Void>? {

            if state == .normal {
                return AssociationKeys.normal.getVoidPointer()
            } else if state == .highlighted {
                return AssociationKeys.highlighted.getVoidPointer()
            } else if state == .selected {
                return AssociationKeys.selected.getVoidPointer()
            } else if state == .disabled {
                return AssociationKeys.disabled.getVoidPointer()
            } else if state == .application {
                return AssociationKeys.application.getVoidPointer()
            } else if state == .reserved {
                return AssociationKeys.reserved.getVoidPointer()
            } else if state == .focused {
                return AssociationKeys.focused.getVoidPointer()
            } else {
                return nil
            }
        }
    }
#endif

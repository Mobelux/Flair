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

        /**
         Sets the background color for the 4 key states (normal, highlighted, selected & disabled) to the values in the `colorSet`
         
         - parameter colorSet: The color set to get the background colors from. If the set is `nil` or a specific color is `nil` then that state will have a nil color
        */
        public func setBackground(colorSet: ColorSet?) {
            setBackgroundColor(color: colorSet?.normalColor.color, for: .normal)
            setBackgroundColor(color: colorSet?.highlightedColor?.color, for: .highlighted)
            setBackgroundColor(color: colorSet?.selectedColor?.color, for: .selected)
            setBackgroundColor(color: colorSet?.disabledColor?.color, for: .disabled)
        }

        /**
         Gets a `ColorSet` that represents the background colors that are currently set. You do not have had to call `setBackground(colorSet:)` first. 
         Just setting 1 or more background colors individually will be enough to rebuild the current `ColorSet`.
         
         - returns: Note that this object will not be the same instance that you set via `setBackground(colorSet:)`, but it may have the same values. It also may be different then that, because you may have changed the background color for an individual state after setting the background color set.
        */
        public func backgroundColorSet() -> ColorSet? {
            guard let normal = backgroundColor(for: .normal), let normalColor = Color(color: normal) else { return nil }
            let highlighted = backgroundColor(for: .highlighted)
            let selected = backgroundColor(for: .selected)
            let disabled = backgroundColor(for: .disabled)
            return ColorSet(normalColor: normalColor, highlightedColor: Color(color: highlighted), selectedColor: Color(color: selected), disabledColor: Color(color: disabled))
        }

        /**
         Sets the title color for the 4 key states (normal, highlighted, selected & disabled) to the values in the `colorSet`. If you set a `style` on this button and it has a `textColor` then this will have no effect.

         - parameter colorSet: The color set to get the title colors from. If the set is `nil` or a specific color is `nil` then that state will have a nil color
        */
        public func setTitle(colorSet: ColorSet?) {
            if let styleColorSet = style?.textColor, styleColorSet != colorSet {
                return
            }
            setTitleColor(colorSet?.normalColor.color, for: .normal)
            setTitleColor(colorSet?.highlightedColor?.color, for: .highlighted)
            setTitleColor(colorSet?.selectedColor?.color, for: .selected)
            setTitleColor(colorSet?.disabledColor?.color, for: .disabled)
        }

        /**
         Gets a `ColorSet` that represents the title colors that are currently set. You do not have had to call `setTitle(colorSet:)` first.
         Just setting 1 or more title colors individually will be enough to rebuild the current `ColorSet`.

         - returns: Note that this object will not be the same instance that you set via `setTitle(colorSet:)`, but it may have the same values. It also may be different then that, because you may have changed the title color for an individual state after setting the title color set.
         */
        public func titleColorSet() -> ColorSet? {
            guard let normal = titleColor(for: .normal), let normalColor = Color(color: normal) else { return nil }
            let highlighted = titleColor(for: .highlighted)
            let selected = titleColor(for: .selected)
            let disabled = titleColor(for: .disabled)
            return ColorSet(normalColor: normalColor, highlightedColor: Color(color: highlighted), selectedColor: Color(color: selected), disabledColor: Color(color: disabled))
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
        
        private func key(for state: UIControlState) -> UnsafeRawPointer? {

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

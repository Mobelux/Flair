//
//  Font.swift
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
    public typealias PlatformFont = UIFont
#elseif os(watchOS)
    import WatchKit
    public typealias PlatformFont = UIFont
#elseif os(OSX)
    import AppKit
    public typealias PlatformFont = NSFont
#endif

/// Platform agnostic Font representation
public struct Font: Equatable {
    
    // MARK: - Enum definations
    
    /**
        The weight of the system font. These correspond to `UIFontWeight` values. Sadly those are just constants, not an enum yet
    */
    public enum Weight: String, Equatable {
        case regular
        case medium
        case bold
        case thin
        case black
        case semibold
        case ultralight
        case light
        
        /// Gets the actual `UIFontWeight...` value
        public var value: CGFloat {
            #if os(iOS) || os(tvOS) || os(watchOS)
                switch self {
                case .regular:
                    return UIFont.Weight.regular.rawValue
                case .medium:
                    return UIFont.Weight.medium.rawValue
                case .bold:
                    return UIFont.Weight.bold.rawValue
                case .thin:
                    return UIFont.Weight.thin.rawValue
                case .black:
                    return UIFont.Weight.black.rawValue
                case .semibold:
                    return UIFont.Weight.semibold.rawValue
                case .ultralight:
                    return UIFont.Weight.ultraLight.rawValue
                case .light:
                    return UIFont.Weight.light.rawValue
                }
            #elseif os(OSX)
                switch self {
                case .regular:
					return NSFont.Weight.regular.rawValue
                case .medium:
					return NSFont.Weight.medium.rawValue
                case .bold:
					return NSFont.Weight.bold.rawValue
                case .thin:
					return NSFont.Weight.thin.rawValue
                case .black:
					return NSFont.Weight.black.rawValue
                case .semibold:
					return NSFont.Weight.semibold.rawValue
                case .ultralight:
					return NSFont.Weight.ultraLight.rawValue
                case .light:
					return NSFont.Weight.light.rawValue
                }
            #endif
        }
    }
    
    /**
        The type of this font
     
        - normal:   A regular font that you refrence by it's PostScript font name
        - system:   A system font of a specific `Weight`
    */
    public enum FontType: Equatable {
        case normal(fontName: String)
        case system(weight: Weight)
    }
    
    /**
        How this text's point size is determined
     
        - staticSize:   The `font.pointSize` should always be equal to `pointSize` and never change
        - dynamicSize:  The `font.pointSize` should be different depending on the user's dynamic text settings. `pointSizeBase` is the desired point size assuming the user's setting is set to default. Once the user's setting isn't default, then when you request `font` the actual `pointSize` used will be calculated by scaling `pointSizeBase` to match the user's size change %.
    */
    public enum SizeType: Equatable {
        case staticSize(pointSize: CGFloat)
        case dynamicSize(pointSizeBase: CGFloat)
    }
    
    // MARK: - Property definitions
    
    public let type: FontType
    public let sizeType: SizeType
    
    /// Get the `PlatformFont` based on the user's current text size settings.
    public var font: PlatformFont? {
        let pointSize = Font.pointSize(for: sizeType)
        
        switch type {
        case .normal(let fontName):
            return PlatformFont(name: fontName, size: pointSize)
        case .system(let weight):
            return PlatformFont.systemFont(ofSize: pointSize, weight: PlatformFont.Weight(rawValue: weight.value))
        }
    }
    
    // MARK: - Initializers
    
    /**
        Initialize a `Font` with a `FontType` & `SizeType` (designated init)
     
        - parameter type:       The `FontType` of the font (normal vs system)
        - parameter sizeType:   The `SizeType` of the font (dynamic vs static) and point size
    */
    public init(type: FontType, sizeType: SizeType) {
        self.type = type
        self.sizeType = sizeType
    }
    
    /**
         Initialize a `Font` from a name & `SizeType`
         
         - parameter fontName:  The font name
         - parameter sizeType:  The `SizeType` of the font (dynamic vs static) and point size
     */
    public init(fontName: String, sizeType: SizeType) {
        let type = FontType.normal(fontName: fontName)
        let sizeType = sizeType
        self.init(type: type, sizeType: sizeType)
    }
    
    /**
        Initialize a `Font` with the system font of a `Weight` & `SizeType`
     
        - parameter weight:     The `Weight` of the font
        - parameter sizeType:   The `SizeType` of the font (dynamic vs static) and point size
    */
    public init(systemFontWeight weight: Weight, sizeType: SizeType) {
        let type = FontType.system(weight: weight)
        self.init(type: type, sizeType: sizeType)
    }
    
    private static func pointSize(for sizeType: SizeType) -> CGFloat {
        switch sizeType {
        case .staticSize(let pointSize):
            return pointSize
        case .dynamicSize(let pointSizeBase):
            return dynamicPointSize(pointSizeBase: pointSizeBase)
        }
    }
    
    private static func dynamicPointSize(pointSizeBase: CGFloat) -> CGFloat {
        #if os(iOS) || os(tvOS) || os(watchOS)
            let defaultFontSize = PlatformFont.labelFontSize
            let adjustedFontSize = PlatformFont.preferredFont(forTextStyle: .body).pointSize
            let scaleFactor = adjustedFontSize / defaultFontSize
            let dynamicPointSize = scaleFactor * pointSizeBase
            return dynamicPointSize
        #elseif os(OSX)
            return pointSizeBase
        #endif
    }
}


// MARK: - Equatable implementations

public func ==(lhs: Font, rhs: Font) -> Bool {
    return lhs.type == rhs.type && lhs.sizeType == rhs.sizeType
}

public func ==(lhs: Font.FontType, rhs: Font.FontType) -> Bool {
    switch (lhs, rhs) {
    case (.normal(let lhsName), .normal(let rhsName)):
        return lhsName == rhsName
    case (.system(let lhsWeight), .system(let rhsWeight)):
        return lhsWeight == rhsWeight
    default:
        return false
    }
}

public func ==(lhs: Font.SizeType, rhs: Font.SizeType) -> Bool {
    switch (lhs, rhs) {
    case (.staticSize(let lhsSize), .staticSize(let rhsSize)):
        return lhsSize == rhsSize
    case (.dynamicSize(let lhsSize), .dynamicSize(let rhsSize)):
        return lhsSize == rhsSize
    default:
        return false
    }
}

public func ==(lhs: Font.Weight, rhs: Font.Weight) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

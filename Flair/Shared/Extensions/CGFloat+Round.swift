//
//  CGFloat+Round.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(watchOS)
    import WatchKit
#elseif os(OSX)
    import AppKit
#endif

extension CGFloat {
    func roundTo(numberOfDecimalPlaces: Int) -> CGFloat {
        let powerOfTen = pow(10, CGFloat(numberOfDecimalPlaces))
        
        let decimalsRemoved = self * powerOfTen
        return decimalsRemoved.rounded() / powerOfTen
    }
}

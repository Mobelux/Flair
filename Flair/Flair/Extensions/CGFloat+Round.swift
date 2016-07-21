//
//  CGFloat+Round.swift
//  Flair
//
//  Created by Jerry Mayers on 7/21/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import UIKit

extension CGFloat {
    func roundTo(numberOfDecimalPlaces: Int) -> CGFloat {
        let powerOfTen = pow(10, CGFloat(numberOfDecimalPlaces))
        
        let decimalsRemoved = self * powerOfTen
        return round(decimalsRemoved) / powerOfTen
    }
}

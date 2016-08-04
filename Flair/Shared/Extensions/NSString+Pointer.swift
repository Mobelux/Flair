//
//  NSString+Pointer.swift
//  Flair
//
//  Created by Jerry Mayers on 7/22/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

extension NSString {
    func getVoidPointer() -> UnsafePointer<Void> {
        let unmanaged = Unmanaged.passUnretained(self)
        return UnsafePointer(unmanaged.toOpaque())
    }
}

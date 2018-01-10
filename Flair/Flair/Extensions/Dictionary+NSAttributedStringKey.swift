//
//  Dictionary+NSAttributedStringKey.swift
//  Flair
//
//  Created by David Martin on 1/9/18.
//  Copyright © 2018 Mobelux. All rights reserved.
//

import Foundation

extension Dictionary where Key == NSAttributedStringKey {
	/// Converts keys from NSAttributedStringKey to String
	func format() -> [String: Value] {
		return reduce(into: [:], {
			$0[$1.key.rawValue] = $1.value
		})
	}
}

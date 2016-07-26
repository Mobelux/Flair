//
//  JSON.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/26/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

public typealias JSONKey = NSObject
public typealias JSONValue = AnyObject

public typealias JSON = [JSONKey : JSONValue]

enum JSONError: Int, ErrorProtocol {
    case unknown = 10
    case unparsableJSON = 11
}

extension Dictionary where Key: JSONKey, Value: JSONValue {
    
    func hash() throws -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: data, encoding: .utf8), jsonString.characters.count > 0 else { throw JSONError.unparsableJSON }
            return (jsonString as NSString).sha256()
        } catch {
            throw JSONError.unparsableJSON
        }
    }
}

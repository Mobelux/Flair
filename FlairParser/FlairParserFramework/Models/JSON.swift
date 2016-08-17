//
//  JSON.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/26/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

public typealias JSONKey = String
public typealias JSONValue = Any

public typealias JSON = [JSONKey : JSONValue]

extension Sequence where Iterator.Element == (key: JSONKey, value: JSONValue) {
    func hash() throws -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: data, encoding: .utf8), jsonString.characters.count > 0 else { throw Parser.ParserError.unreadableJSONSyntax }
            return (jsonString as NSString).sha256()
        } catch {
            throw Parser.ParserError.unreadableJSONSyntax
        }
    }
}

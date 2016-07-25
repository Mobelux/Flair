//
//  LegacyParser.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/22/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

@objc public class LegacyParser: NSObject {
    @objc public static func parse(json: URL, outputDirectory: URL) -> NSError? {
        do {
            let parser = try Parser(json: json)
            return nil
        } catch let error as Parser.Error {
            return error.legacyError
        } catch {
            return Parser.Error.unknown.legacyError
        }
    }
}

//
//  Parser.swift
//  FlairParser
//
//  Created by Jerry Mayers on 7/22/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

import Foundation

public struct Parser {

    public enum Error: Int, ErrorProtocol {
        case unknown = 10
        case cantOpenJSONFile = 11
        case unreadableJSONSyntax = 12
        
        static let domain = "com.mobelux.flair.parser"
        
        var legacyError: NSError {
            let message: String = {
                switch self {
                case .cantOpenJSONFile:
                    return "Unable to open JSON file for parsing"
                case .unknown:
                    return "Unknown error"
                case .unreadableJSONSyntax:
                    return "The JSON file has a syntax error that prevents parsing"
                }
            }()
            return NSError(domain: Error.domain, code: rawValue, userInfo: [NSLocalizedDescriptionKey : message])
        }
    }
    
    typealias JSON = [NSObject : AnyObject];
    private let json: JSON
    
    public init(json: URL) throws {
        do {
            let data = try Data(contentsOf: json)
            do {
                guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
                    throw Error.unreadableJSONSyntax
                }
                
                self.json = jsonDict
            } catch {
                throw Error.unreadableJSONSyntax
            }
        } catch {
            throw Error.cantOpenJSONFile
        }
    }
}

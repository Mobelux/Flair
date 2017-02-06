//
//  ArgumentParser.swift
//  FlairParser
//
//  Created by Jerry Mayers on 2/6/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

public class ArgumentParser: NSObject {

    @objc public static func parse(arguments: [String]) -> Int {
        if arguments.contains("--version") {
            displayVersion()
            return 0
        } else if arguments.count < 5 || arguments.count > 5 || arguments.contains("--help") {
            displayHelp()
            return arguments.count < 5 || arguments.count > 5 ? 1 : 0
        } else {
            guard let outputDirectoryURL = self.outputDirectory(for: arguments), let jsonURL = self.json(for: arguments) else {
                displayHelp()
                return 1
            }

            do {
                let parser = try Parser(json: jsonURL)
                let (colors, styles, jsonHash) = try parser.parse()
                try Generator.generate(colors: colors, styles: styles, outputDirectory: outputDirectoryURL, jsonHash: jsonHash)
                return 0
            } catch let error as Parser.ParserError {
                print("\(error.legacyError.code) - \(error.localizedDescription)")
                return error.legacyError.code
            } catch {
                let error = Parser.ParserError.unknown.legacyError
                print("\(error.code) - \(error.localizedDescription)")
                return error.code
            }
        }
    }

    static func displayVersion() {
        guard let info = Bundle(for: ArgumentParser.self).infoDictionary, let version = info["CFBundleShortVersionString"] as? String else { return }
        print(version)
    }

    static func displayHelp() {
        let helpMessage = "This is a application that will parse JSON color/style files into Swift code.\nIt will build that code as extensions on Style & ColorSet from Flair\n\nUsage: \nFlairParser --output <path> --json <path>\nArguments:\n--help Will display this message\n--version Will display this app's version\n--output <path to output folder> The folder to save all generated style files\n--json <path to colors/styles json> The location & name of the style.json file\n"
        print(helpMessage)
    }

    static func outputDirectory(for arguments: [String]) -> URL? {
        guard let outputArgumentIndex = arguments.index(of: "--output"), arguments.count >= outputArgumentIndex + 2 else { return nil }
        let outputDirectoryArgumentIndex = outputArgumentIndex + 1
        let outputDirectory = arguments[outputDirectoryArgumentIndex] as NSString
        let expandedOutputDirectory = outputDirectory.expandingTildeInPath
        return URL(fileURLWithPath: expandedOutputDirectory)
    }

    static func json(for arguments: [String]) -> URL? {
        guard let jsonArgumentIndex = arguments.index(of: "--json"), arguments.count >= jsonArgumentIndex + 2 else { return nil }
        let jsonFileArgumentIndex = jsonArgumentIndex + 1
        let jsonFile = arguments[jsonFileArgumentIndex] as NSString
        let expandedJSONFile = jsonFile.expandingTildeInPath
        return URL(fileURLWithPath: expandedJSONFile)
    }
}

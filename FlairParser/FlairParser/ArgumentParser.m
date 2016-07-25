//
//  ArgumentParser.m
//  FlairParser
//
//  Created by Jerry Mayers on 7/22/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

#import "ArgumentParser.h"
@import FlairParserFramework;

@implementation ArgumentParser

    + (int)parseArguments:(NSArray<NSString *> *)arguments {
        if ((![arguments containsObject:@"--version"] && arguments.count < 5) || [arguments containsObject:@"--help"]) {
            [self displayHelp];
            return 0;
        } else if ([arguments containsObject:@"--version"]) {
            [self displayVersion];
            return 0;
        } else {
            NSURL *outputDirectoryURL = [self outputDirectoryFor:arguments];
            NSURL *jsonURL = [self jsonURLFor:arguments];
            
            if (outputDirectoryURL != nil && jsonURL != nil) {
                NSError *error = [LegacyParser parseWithJson:jsonURL outputDirectory:outputDirectoryURL];
                if (error == nil) {
                    return 0;
                } else {
                    NSLog(@"%@", error);
                    return (int)error.code;
                }
            } else {
                [self displayHelp];
                return 1;
            }
        }
    }
    
    + (void)displayVersion {
        NSString *version = @"1.0.0";
        NSLog(@"%@", version);
    }
    
    + (void)displayHelp {
        NSString *helpMessage = @"This is a application that will parse JSON color/style files into Swift code.\nIt will build that code as extensions on Style & ColorSet from Flair\n\nUsage: \nFlairParser --output <path> --json <path>\nArguments:\n--help Will display this message\n--version Will display this app's version\n--output <path to output folder> The folder to save all generated style files\n--json <path to colors/styles json> The location & name of the style.json file\n";
        
        NSLog(@"%@", helpMessage);
    }
    
    + (nullable NSURL *)outputDirectoryFor:(NSArray<NSString *> *)arguments {
        NSUInteger outputIndex = [arguments indexOfObject:@"--output"];
        NSUInteger outputDirectoryIndex = outputIndex + 1;
        if (outputIndex != NSNotFound && outputDirectoryIndex < arguments.count) {
            NSString *expandedOutputDirectory = [arguments[outputDirectoryIndex] stringByExpandingTildeInPath];
            return [[NSURL alloc] initFileURLWithPath:expandedOutputDirectory isDirectory:YES];
        }
        return nil;
    }
    
    + (nullable NSURL *)jsonURLFor:(NSArray<NSString *> *)arguments {
        NSUInteger jsonIndex = [arguments indexOfObject:@"--json"];
        NSUInteger jsonFileIndex = jsonIndex + 1;
        if (jsonIndex != NSNotFound && jsonFileIndex < arguments.count) {
            NSString *expandedJSONPath = [arguments[jsonFileIndex] stringByExpandingTildeInPath];
            return [[NSURL alloc] initFileURLWithPath:expandedJSONPath isDirectory:NO];
        }
        return nil;
    }
    
@end

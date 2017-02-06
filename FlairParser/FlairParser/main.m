//
//  main.m
//  FlairParser
//
//  Created by Jerry Mayers on 7/22/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

#import <Foundation/Foundation.h>
@import FlairParserFramework;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray<NSString *> *arguments = [[NSMutableArray alloc] initWithCapacity:argc];
        for (int argumentIndex = 0; argumentIndex < argc; argumentIndex += 1) {
            NSString *argument = [NSString stringWithUTF8String:argv[argumentIndex]];
            [arguments addObject:argument];
        }
        
        return (int)[ArgumentParser parseWithArguments:arguments];
    }
}

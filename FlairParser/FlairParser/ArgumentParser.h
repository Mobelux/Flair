//
//  ArgumentParser.h
//  FlairParser
//
//  Created by Jerry Mayers on 7/22/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArgumentParser : NSObject

    + (int)parseArguments:(NSArray<NSString *> *)arguments;
    
@end

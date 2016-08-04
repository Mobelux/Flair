//
//  NSString+SHA256.h
//  FlairParser
//
//  Created by Jerry Mayers on 7/26/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SHA256)

- (NSData *)sha256Data;
- (NSString *)sha256String;
    
@end

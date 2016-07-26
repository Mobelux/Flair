//
//  NSString+SHA256.m
//  FlairParser
//
//  Created by Jerry Mayers on 7/26/16.
//  Copyright © 2016 Mobelux. All rights reserved.
//

#import "NSString+SHA256.h"
#import <CommonCrypto/CommonCrypto.h>

// This file is in Objective-C because you can't import CommonCrypto without a bunch of hacky things
@implementation NSString (SHA256)
    
- (NSData *)sha256Data {
    NSData *shaData;
    if ([self length] > 0) {
        NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
        unsigned char digest[CC_SHA256_DIGEST_LENGTH];
        if (CC_SHA256([stringData bytes], (CC_LONG)[stringData length], digest)) {
            shaData = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
        }
    }
    
    return shaData;
}
    
- (NSString *)sha256String {
    NSMutableString *output;
    NSData *shaData = [self sha256Data];
    if (shaData) {
        output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
        const char * shaBytes = [shaData bytes];
        for (CC_LONG i = 0; i < [shaData length]; i++) {
            [output appendFormat:@"%02x", (unsigned char)shaBytes[i]];
        }
    }
    return output;
}

@end

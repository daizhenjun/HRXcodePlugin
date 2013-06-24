//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军
//

#import <Foundation/Foundation.h>

@interface DZTools : NSObject
+ (BOOL) isValidString:(id)input;
+ (NSString *)urlEncode:(NSString *)str stringEncode:(CFStringEncoding)encode;
+ (NSString *)urlEncodeValue:(NSString *)str;
+ (NSString *)getFirstLetterUpper:(NSString*) str;
@end

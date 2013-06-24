//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军
//

#import "DZTools.h"

@implementation DZTools

+ (BOOL) isValidString:(id)input
{
    if (!input || (NSNull *)input == [NSNull null] || ![input isKindOfClass:[NSString class]]) {
        return NO;
    }
    if ([input isEqualToString:@""] || ((NSString*)input).length <= 0 ) {
        return NO;
    }
    return YES;
}

+ (NSString *)urlEncode:(NSString *)str stringEncode:(CFStringEncoding)encode
{
    NSString *resultStr = str;
    CFStringRef originalString = (CFStringRef) str;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         encode);
    if(escapedStr)
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(NSString *)escapedStr];
        CFRelease(escapedStr);
        if (!mutableStr || [mutableStr isKindOfClass:[NSNull class]] || mutableStr.length <= 0) {
            return resultStr;
        }
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}

+ (NSString *)urlEncodeValue:(NSString *)str
{
    return [DZTools urlEncode:str stringEncode:kCFStringEncodingUTF8];
}


+ (NSString *)getFirstLetterUpper:(NSString*) str{
    NSString * firstLetter = [str substringToIndex:1];
    return [[firstLetter uppercaseString] stringByAppendingString: [str substringFromIndex:1]];
}

@end

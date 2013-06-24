//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import "RegexController.h"
#import "DZTools.h"

@interface RegexController ()

@end

@implementation RegexController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
//        [[NSNotificationCenter defaultCenter]
//         addObserver:self
//         selector:@selector(startRegMatch:)
//         name:NSControlTextDidChangeNotification
//         object:self.inputString];
    }
    
    return self;
}

NSString* httpUrlReg = @"(http|https)\://([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&%\$\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{1,10}))(\:[0-9]+)*(/($|[a-zA-Z0-9\.\,\?\'\\\+&%\$#\=~_\-]+))*$";

NSString* emailReg  = @"([\\w\\.\\-]+)@([\\w\\-]+)((\\.(\\w){2,3})+)$";
NSString* emailReg1 = @"\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}\\b";
NSString* ipReg     = @"\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\z";
NSString* dateReg   = @"((((1[6-9]|[2-9]\\d)\\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\\d|3[01]))|(((1[6-9]|[2-9]\\d)\\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\\d|30))|(((1[6-9]|[2-9]\\d)\\d{2})-0?2-(0?[1-9]|1\\d|2[0-9]))|(((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$";

- (void)windowDidLoad
{
    [super windowDidLoad];
}

-(NSString*) getRegexExpression{
    NSText *textEditor = [self.regexText currentEditor];
    NSArray* selectedRanges = [textEditor selectedRanges];
    if ( [[selectedRanges objectAtIndex:0] rangeValue].length==0) {
        return [self.regexText stringValue];
    }
    NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
    return [[self.regexText stringValue] substringWithRange:selectedRange];
}


-(void) startRegMatch{
    [self.outPutText setStringValue: @""];
    NSString *inputString = [self.inputString stringValue];
    NSError *error = NULL;
    NSString *expression = [self getRegexExpression];
    if([DZTools isValidString:expression] && [DZTools isValidString:inputString]){
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:expression
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
        [regex enumerateMatchesInString:inputString options:0 range:NSMakeRange(0, [inputString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
            NSRange matchRange = [match range];
            NSMutableAttributedString *attributedString = [self.inputString.attributedStringValue mutableCopy];
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[NSColor redColor]
                                     range:matchRange];
            self.outPutText.attributedStringValue = attributedString;
            if (matchRange.location == NSNotFound){
                *stop = YES;
            }
        }];
    }
}


-(IBAction)httpClick:(id)sender{
    [self.regexText setStringValue: httpUrlReg];
    [self.inputString setStringValue: @"Http: http://www.baidu.com"];
    [self runClick:nil];
}

-(IBAction)emailClick:(id)sender{
    [self.regexText setStringValue: emailReg];
    [self.inputString setStringValue: @"email: daizhj@gamil.com"];
    [self runClick:nil];
}

-(IBAction)ipClick:(id)sender{
    [self.regexText setStringValue: ipReg];
    [self.inputString setStringValue: @"ip: 192.168.0.1"];
    [self runClick:nil];
}

-(IBAction)dateClick:(id)sender{
    [self.regexText setStringValue: dateReg];
    [self.inputString setStringValue: @"date: 1976-08-01"];
    [self runClick:nil];
}

-(IBAction)runClick:(id)sender{
    [self startRegMatch];
}

-(IBAction)codeClick:(id)sender{
    NSString* regexStr = [self.regexText stringValue];
    regexStr = [regexStr stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    [self.codeText setStringValue:[NSString stringWithFormat:@"NSString *regExp = @\"%@\";", regexStr]];
}
@end

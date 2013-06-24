//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import "ReplaceContent.h"
#import "Serializer.h"


@interface ReplaceContent ()

@end

@implementation ReplaceContent

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    CommonConfig *config = [CommonConfig get:COMMON_CONFIG_KEY];
    [self.svnPath setStringValue: config.svnPath];
    [self.gitPath setStringValue: config.gitPath];
    
//    [self.oldText setStringValue: self.replace];
//    //[self.newText setStringValue: @"adfadf"];
//    NSLog(@"title is %@", self.replace);
    
//    self.button = [[NSButton alloc] initWithFrame: NSMakeRect(10, 40, 90, 40)];
//    [self.button setTarget:self];
//    [self.button setAction:@selector(button_click:)];
}

-(IBAction)button_click:(id)sender{
//    [self.oldText setStringValue: [self.newText stringValue]] ;
//    [self close];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"start_replace" object:[self.newText stringValue]];
    //[self.parendWindow performSelectorOnMainThread:self.replaceCallBack withObject:[self.newText stringValue] waitUntilDone:YES];
   // [self.parendWindow performSelectorInBackground:self.replaceCallBack withObject:[self.newText stringValue]];
    
    //save CommonConfig
    CommonConfig *config = [[CommonConfig alloc] init];
    config.svnPath = [self.svnPath stringValue];
    config.gitPath = [self.gitPath stringValue];
    [config set:COMMON_CONFIG_KEY];
    
    [self close];
    
}



@end

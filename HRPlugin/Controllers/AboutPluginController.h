//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import <Cocoa/Cocoa.h>

@interface AboutPluginController : NSWindowController

@property (nonatomic, retain) IBOutlet NSButton *visitHome;

-(IBAction)visitHome_click:(id)sender;

@end
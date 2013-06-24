//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import <Cocoa/Cocoa.h>

@interface ConfigController : NSWindowController
@property (nonatomic, retain) IBOutlet NSTextField *svnPath;
@property (nonatomic, retain) IBOutlet NSTextField *gitPath;
@property (nonatomic, retain) IBOutlet NSButton *svnButton;
@property (nonatomic, retain) IBOutlet NSButton *gitButton;
@property (nonatomic, retain) IBOutlet NSButton *saveButton;

-(IBAction)saveClick:(id)sender;
-(IBAction)svnClick:(id)sender;
-(IBAction)gitClick:(id)sender;
@end

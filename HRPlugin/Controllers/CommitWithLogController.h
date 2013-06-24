//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import <Cocoa/Cocoa.h>

@interface CommitWithLogController : NSWindowController
@property (nonatomic) BOOL isGit;
@property (nonatomic, retain) IBOutlet NSTextField *localPath;
@property (nonatomic, retain) IBOutlet NSTextField *logText;
@property (nonatomic, retain) IBOutlet NSButton *submitButton;

-(IBAction)submitClick:(id)sender;
@end

//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军
#import <Cocoa/Cocoa.h>

//#import <UIKit/UIKit.h>
@interface ReplaceContent : NSWindowController
@property (nonatomic, retain) IBOutlet NSTextField *svnPath;
@property (nonatomic, retain) IBOutlet NSTextField *gitPath;
@property (nonatomic, retain) IBOutlet NSButton *saveButton;
@property (nonatomic, retain) NSString *replace;

-(IBAction)button_click:(id)sender;

//call back function
//@property SEL replaceCallBack;
//@property (nonatomic, retain) id parendWindow;
@end

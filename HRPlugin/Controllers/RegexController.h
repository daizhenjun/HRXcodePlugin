//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import <Cocoa/Cocoa.h>

@interface RegexController : NSWindowController
@property (nonatomic, retain) IBOutlet NSTextField *regexText;
@property (nonatomic, retain) IBOutlet NSTextField *inputString;
@property (nonatomic, retain) IBOutlet NSTextField *outPutText;
@property (nonatomic, retain) IBOutlet NSTextField *codeText;
@property (nonatomic, retain) IBOutlet NSButton *runButton;
@property (nonatomic, retain) IBOutlet NSButton *emailButton;
@property (nonatomic, retain) IBOutlet NSButton *ipButton;
@property (nonatomic, retain) IBOutlet NSButton *dateButton;
@property (nonatomic, retain) IBOutlet NSButton *codeButton;
@property (nonatomic, retain) IBOutlet NSButton *httpButton;
-(IBAction)runClick:(id)sender;
-(IBAction)emailClick:(id)sender;
-(IBAction)ipClick:(id)sender;
-(IBAction)dateClick:(id)sender;
-(IBAction)codeClick:(id)sender;
-(IBAction)httpClick:(id)sender;
@end

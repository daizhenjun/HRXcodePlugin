//
//  HttpProxyController.h
//  test
//
//  Created by 代 震军 on 13-6-13.
//  Copyright (c) 2013年 代 震军. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HttpProxyController : NSWindowController
@property (nonatomic, retain) IBOutlet NSButton *demoButton;
@property (nonatomic, retain) IBOutlet NSButton *startListenButton;
@property (nonatomic, retain) IBOutlet NSButton *clearButton;
@property (nonatomic, retain) IBOutlet NSTextField *serverOutput;
@property (nonatomic, retain) IBOutlet NSTextField *clientOutput;
@property (nonatomic, retain) IBOutlet NSTextField *listenPort;
-(IBAction)startListenClick:(id)sender;
-(IBAction)clearClick:(id)sender;
-(IBAction)demoClick:(id)sender;
@end

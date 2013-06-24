//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import <Cocoa/Cocoa.h>
//#import <Foundation/Foundation.h>

@interface NSMenuItem (MenuBlockActions)

//- (void) addEventHandler:(void(^)(void))handler;
- (void) invokeBlocks:(id)sender ;
- (id)initWithTitleBlock:(NSString*)title bindBlock:(void(^)(void))handler;
@end
//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import "NSMenuBlockActionExtension.h"

#import <objc/runtime.h>

@interface MenuBlockActionWrapper : NSObject
@property (nonatomic, copy) void (^blockAction)(void);
- (void) invokeBlock:(id)sender;
@end

@implementation MenuBlockActionWrapper
@synthesize blockAction;
- (void) dealloc {
    [self setBlockAction:nil];
    [super dealloc];
}

- (void) invokeBlock:(id)sender {
    [self blockAction]();
}
@end

@implementation NSMenuItem (MenuBlockActions)

static const char * NSMenuBlockActions = "unique_menublock";

//- (void) addEventHandler:(void(^)(void))handler{
//    
//    NSMutableArray * blockActions =
//    objc_getAssociatedObject(self, &NSMenuBlockActions);
//    
//    if (blockActions == nil) {
//        blockActions = [NSMutableArray array];
//        objc_setAssociatedObject(self, &NSMenuBlockActions,
//                                 blockActions, OBJC_ASSOCIATION_RETAIN);
//    }
//    
//    MenuBlockActionWrapper * target = [[MenuBlockActionWrapper alloc] init];
//    [target setBlockAction:handler];
//    [blockActions addObject:target];
//    
//    self.action = @selector(invokeBlock:);
//    [target release];
//}

- (void) invokeBlocks:(id)sender {
}

- (id) initWithTitleBlock:(NSString*)title bindBlock:(void(^)(void))handler{
    
    NSMutableArray * blockActions =
    objc_getAssociatedObject(self, &NSMenuBlockActions);
    
    if (blockActions == nil) {
        blockActions = [NSMutableArray array];
        objc_setAssociatedObject(self, &NSMenuBlockActions,
                                 blockActions, OBJC_ASSOCIATION_RETAIN);
    }
    
    MenuBlockActionWrapper * target = [[[MenuBlockActionWrapper alloc] init] autorelease];
    [target setBlockAction:handler];
    [blockActions addObject:target];
    [target retain];
    [self setTitle:title];
    [self setAction:@selector(invokeBlocks:)];
    //return [[NSMenuItem alloc] initWithTitle:title action:@selector(invokeBlock:) keyEquivalent:@""];
    return self;
}


@end

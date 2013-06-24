//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#ifndef MyNavSample_NSCodeBase_h
#define MyNavSample_NSCodeBase_h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define COMMON_CONFIG_KEY @"COMMON_CONFIG_KEY"

@protocol CoderProtocol
- (id) initWithCoder: (NSCoder *)coder;
- (void) encodeWithCoder: (NSCoder *)coder;
@end;

//序列化构造器，用于保存对象
@interface Serializer : NSObject <NSCoding, CoderProtocol>{}
+ (id) get:(NSString*)_key;
- (void) set:(NSString*)_key;
@end;


//CommonConfig
@interface CommonConfig : Serializer
@property (nonatomic, retain) NSString *svnPath;
@property (nonatomic, retain) NSString *gitPath;
@property (nonatomic, retain) NSString *dbPath;
@end;





#endif

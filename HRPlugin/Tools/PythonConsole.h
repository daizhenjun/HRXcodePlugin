//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

/*
 Add the Python.framework to your project (Right click External Frameworks.., Add > Existing Frameworks. The framework in in /System/Library/Frameworks/
 Add /System/Library/Frameworks/Python.framework/Headers to your "Header Search Path" (Project > Edit Project Settings)
 */

#import <Foundation/Foundation.h>

@interface PythonConsole : NSObject
+(NSString*) RunConsole:(NSString*) commandLine;
+(void) showMessage:(NSString*) message;
+(void) SVNCommit:(NSString*)log;
+(void) SVNUpdate;
+(void) SVNCleanup;
+(void) SVNLog;
+(void) SVNAdd;

+(void) GitCommit:(NSString*)log;
+(void) GitPull;
+(void) GitStatus;
+(void) GitAdd;
@end

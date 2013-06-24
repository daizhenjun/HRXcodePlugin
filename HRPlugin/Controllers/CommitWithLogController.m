//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import "CommitWithLogController.h"
#import "Serializer.h"
#import "PythonConsole.h"

@interface CommitWithLogController ()

@end

@implementation CommitWithLogController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    CommonConfig *config = [CommonConfig get:COMMON_CONFIG_KEY];
    if(config != nil){
        if([self isGit] == NO){
            [self.localPath setStringValue: config.svnPath];
        }else{
            [self.localPath setStringValue: config.gitPath];
        }
    }else{
        if([self isGit] == NO){
            [self.localPath setStringValue: @"未设置SVN本地路径"];
        }else{
            [self.localPath setStringValue: @"未设置Git本地路径"];
        }
    }
}


-(IBAction)submitClick:(id)sender{
    //save CommonConfig
    [PythonConsole SVNCommit:[self.logText stringValue]];
    [self close];
}

@end

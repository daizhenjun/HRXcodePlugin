//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import "ConfigController.h"
#import "Serializer.h"

@interface ConfigController ()

@end

@implementation ConfigController

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
        [self.svnPath setStringValue: config.svnPath];
        [self.gitPath setStringValue: config.gitPath];
    }
}


-(IBAction)saveClick:(id)sender{
    //save CommonConfig
    CommonConfig *config = [[CommonConfig alloc] init];
    config.svnPath = [self.svnPath stringValue];
    config.gitPath = [self.gitPath stringValue];
    [config set:COMMON_CONFIG_KEY];
    [self close];
}


-(IBAction)svnClick:(id)sender{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setTitle:@"Svn本地路径"];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton ){
        NSArray* files = [openDlg filenames];
        if([files count] > 0){
            NSFileManager *manager = [NSFileManager defaultManager];
            if([manager fileExistsAtPath:[files objectAtIndex:0]]){
                [self.svnPath setStringValue: [files objectAtIndex:0]];
            }
        }
    }
}
-(IBAction)gitClick:(id)sender{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setTitle:@"Git本地路径"];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton ){
        NSArray* files = [openDlg filenames];
        if([files count] > 0){
            NSFileManager *manager = [NSFileManager defaultManager];
            if([manager fileExistsAtPath:[files objectAtIndex:0]]){
                [self.gitPath setStringValue: [files objectAtIndex:0]];
            }
        }
    }
}

@end

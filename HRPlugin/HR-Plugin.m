//
//  HR-Plugin.m
//  HRPlugin
//
//  Created by 代 震军 on 13-6-7.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "HR-Plugin.h"


#import "NSView+Dumping.h"
#import "ReplaceContent.h"
#import "AboutPluginController.h"
#import "DZTools.h"
#import "PythonConsole.h"
#import "Serializer.h"
#import "ConfigController.h"
#import "CommitWithLogController.h"
#import "SqliteController.h"
#import "RegexController.h"
@interface HR_Plugin()
@property (nonatomic,retain) NSString *selectedText;
@end

@implementation HR_Plugin


+ (void) pluginDidLoad: (NSBundle*) plugin {
    NSLog(@"HR_Plugin");
    // SqlLiteDBHelperDemo();
    [self shared];
}

+(id) shared {
    static dispatch_once_t once;
    static id instance = nil;
	dispatch_once(&once, ^{
		instance = [[self alloc] init];
	});
    return instance;
}

- (id)init {
	if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationListener:) name:nil object:nil];
	}
	return self;
}

- (void) loadPlugInMenu{
    //[self PythonTest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionDidChange:) name:NSTextViewDidChangeSelectionNotification object:nil];
        NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
        if (editMenuItem) {
            [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
    
            NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:@"Google Search" action:@selector(showSelected:) keyEquivalent:@""];
    
            [newMenuItem setTarget:self];
            [newMenuItem setKeyEquivalentModifierMask: NSAlternateKeyMask];
            [[editMenuItem submenu] addItem:newMenuItem];
            [newMenuItem release];
        }
    
//    //添加菜单参见https://github.com/Dwarfartisan/BlackCookbook/blob/master/objc/statusmenu/MainMenu.m
//    // Add the submenu
//    NSMenu *newMenu  = [[NSMenu allocWithZone:[NSMenu menuZone]]
//                        initWithTitle:@"HR-Plugin"];
//    NSMenuItem *newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
//                           initWithTitle:@"HR-Plugin" action:NULL keyEquivalent:@""];
//    
//    //add google search
//    NSMenuItem *googleSearch = [[NSMenuItem alloc] initWithTitle:@"Google Search" action:@selector(gotoGoogleSearch:) keyEquivalent:@""];
//    [googleSearch setTarget:self];
//    [googleSearch setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:googleSearch];
//    [googleSearch release];
//    
//    //add baidu search
//    NSMenuItem *baiduSearch = [[NSMenuItem alloc] initWithTitle:@"Baidu Search" action:@selector(gotoBaiduSearch:) keyEquivalent:@""];
//    [baiduSearch setTarget:self];
//    [baiduSearch setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:baiduSearch];
//    [baiduSearch release];
//    
//    //add splitter
//    [newMenu addItem:[NSMenuItem separatorItem]];
//    
//    /*******************************svn menu*******************************/
//    NSMenuItem *svnCommit = [[NSMenuItem alloc] initWithTitle:@"SVN Commit" action:@selector(gotoSVNCommit:) keyEquivalent:@""];
//    [svnCommit setTarget:self];
//    [svnCommit setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:svnCommit];
//    
//    NSMenu *svnCommitMenu = [[NSMenu allocWithZone:[NSMenu menuZone]]
//                             initWithTitle:@"Commit With Log"];
//    NSMenuItem *svnCommitItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
//                                 initWithTitle:@"Commit With Log" action:NULL keyEquivalent:@""];
//    NSMenuItem *svnCommitWithLog = [[NSMenuItem alloc] initWithTitle:@"Commit With Log" action:@selector(gotoSvnCommitWithLog:) keyEquivalent:@""];
//    [svnCommitWithLog setTarget:self];
//    [svnCommitWithLog setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [svnCommitMenu addItem:svnCommitWithLog];
//    [svnCommitWithLog release];
//    [svnCommitItem setTarget:self];
//    [svnCommitItem setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [svnCommit setSubmenu: svnCommitMenu];
//    [svnCommitItem release];
//    [svnCommit release];
//    
//    
//    
//    NSMenuItem *svnUpdate = [[NSMenuItem alloc] initWithTitle:@"SVN Update" action:@selector(gotoSVNUpdate:) keyEquivalent:@""];
//    [svnUpdate setTarget:self];
//    [svnUpdate setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:svnUpdate];
//    [svnUpdate release];
//    
//    NSMenuItem *svnLog = [[NSMenuItem alloc] initWithTitle:@"SVN Log" action:@selector(gotoSVNLog:) keyEquivalent:@""];
//    [svnLog setTarget:self];
//    [svnLog setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:svnLog];
//    [svnLog release];
//    
//    NSMenuItem *svnAdd = [[NSMenuItem alloc] initWithTitle:@"SVN Add" action:@selector(gotoSVNAdd:) keyEquivalent:@""];
//    [svnAdd setTarget:self];
//    [svnAdd setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:svnAdd];
//    [svnAdd release];
//    
//    //add splitter
//    [newMenu addItem:[NSMenuItem separatorItem]];
//    
//    
//    /*******************************git menu*******************************/
//    NSMenuItem *gitCommit = [[NSMenuItem alloc] initWithTitle:@"Git Commit" action:@selector(gotoSVNCommit:) keyEquivalent:@""];
//    [gitCommit setTarget:self];
//    [gitCommit setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:gitCommit];
//    
//    NSMenu *gitCommitMenu = [[NSMenu allocWithZone:[NSMenu menuZone]]
//                             initWithTitle:@"Commit With Log"];
//    NSMenuItem *gitCommitItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
//                                 initWithTitle:@"Commit With Log" action:NULL keyEquivalent:@""];
//    NSMenuItem *gitCommitWithLog = [[NSMenuItem alloc] initWithTitle:@"Commit With Log" action:@selector(gotoSvnCommitWithLog:) keyEquivalent:@""];
//    [gitCommitWithLog setTarget:self];
//    [gitCommitWithLog setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [gitCommitMenu addItem:gitCommitWithLog];
//    [gitCommitWithLog release];
//    [gitCommitItem setTarget:self];
//    [gitCommitItem setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [gitCommit setSubmenu: gitCommitMenu];
//    [gitCommitItem release];
//    [gitCommit release];
//    
//    NSMenuItem *gitPull = [[NSMenuItem alloc] initWithTitle:@"Git Pull" action:@selector(gotoSVNUpdate:) keyEquivalent:@""];
//    [gitPull setTarget:self];
//    [gitPull setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:gitPull];
//    [gitPull release];
//    
//    NSMenuItem *svnStatus = [[NSMenuItem alloc] initWithTitle:@"Git Status" action:@selector(gotoSVNLog:) keyEquivalent:@""];
//    [svnStatus setTarget:self];
//    [svnStatus setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:svnStatus];
//    [svnStatus release];
//    
//    NSMenuItem *gitAdd = [[NSMenuItem alloc] initWithTitle:@"Git Add" action:@selector(gotoSVNAdd:) keyEquivalent:@""];
//    [gitAdd setTarget:self];
//    [gitAdd setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:gitAdd];
//    [gitAdd release];
//    
//    //add splitter
//    [newMenu addItem:[NSMenuItem separatorItem]];
//    
//    
//    /*******************************sqlite menu*******************************/
//    NSMenuItem *sqlite = [[NSMenuItem alloc] initWithTitle:@"Sqlite Helper" action:@selector(gotoSqliteHelper:) keyEquivalent:@""];
//    [sqlite setTarget:self];
//    [sqlite setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:sqlite];
//    [sqlite release];
//    
//    
//    /*******************************Regex menu*******************************/
//    NSMenuItem *regexConsole = [[NSMenuItem alloc] initWithTitle:@"Regex Console" action:@selector(gotoRegexConsole:) keyEquivalent:@""];
//    [regexConsole setTarget:self];
//    [regexConsole setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:regexConsole];
//    [regexConsole release];
//    
//    
//    //add splitter
//    [newMenu addItem:[NSMenuItem separatorItem]];
//    //add config menu
//    NSMenuItem *saveConfig = [[NSMenuItem alloc] initWithTitle:@"Save Config" action:@selector(gotoConfig:) keyEquivalent:@""];
//    [saveConfig setTarget:self];
//    [saveConfig setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:saveConfig];
//    [saveConfig release];
//    
//    //add splitter
//    [newMenu addItem:[NSMenuItem separatorItem]];
//    
//    //add about menu
//    NSMenuItem *aboutPlugin = [[NSMenuItem alloc] initWithTitle:@"About Plugin" action:@selector(gotoAboutPlugin:) keyEquivalent:@""];
//    [aboutPlugin setTarget:self];
//    [aboutPlugin setKeyEquivalentModifierMask: NSAlternateKeyMask];
//    [newMenu addItem:aboutPlugin];
//    [aboutPlugin release];
//    
//    /*******************************Regex menu*******************************/
////    NSMenuItem *uninstall = [[NSMenuItem alloc] initWithTitle:@"Uninstall" action:@selector(gotoUninstall:) keyEquivalent:@""];
////    [uninstall setTarget:self];
////    [uninstall setKeyEquivalentModifierMask: NSAlternateKeyMask];
////    [newMenu addItem:uninstall];
////    [uninstall release];
//    
//    
//    
//    [newItem setSubmenu:newMenu];
//    [newMenu release];
//    [[NSApp mainMenu] addItem:newItem];
//    [newItem release];
}

- (void) applicationDidFinishLaunching: (NSNotification*) noti {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectionDidChange:)
                                                 name:NSTextViewDidChangeSelectionNotification
                                               object:nil];
    [self loadPlugInMenu];
}

- (IBAction)createTag:(id)sender{
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert setMessageText: @"右击菜单"];
    [alert runModal];
}

-(void) selectionDidChange:(NSNotification *)noti {
    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        NSTextView* textView = (NSTextView *)[noti object];
        
        NSArray* selectedRanges = [textView selectedRanges];
        if (selectedRanges.count==0) {
            return;
        }
        
        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
        NSString* text = textView.textStorage.string;
        self.selectedText = [text substringWithRange:selectedRange];
    }
}


//-(void) showSelected:(NSNotification *)noti {
//    //Log view hierarchy of Xcode
//    //[[[NSApp mainWindow] contentView] dumpWithIndent:@""];
//
//    ReplaceContent *windowController = [[ReplaceContent alloc] initWithWindowNibName :@"ReplaceContent"];
//    windowController.replace = self.selectedText;
//    //windowController.parendWindow = self;
//    //windowController.replaceCallBack = @selector(startReplacement);
//    [windowController showWindow:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startReplacement:)   name:@"start_replace" object:nil];
//}


-(void)gotoGoogleSearch:(NSNotification *)noti
{
    if([DZTools isValidString:self.selectedText]){
        NSString *searchText = [self.selectedText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *url = [NSString stringWithFormat:@"http://www.google.com.hk/search?q=stackoverflow+%@",searchText];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
        NSLog(@"google url :%@",url);
    }
}

-(void)gotoBaiduSearch:(NSNotification *)noti{
    if([DZTools isValidString:self.selectedText]){
        NSString *searchText = [self.selectedText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *url = [NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",searchText];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
        NSLog(@"baidu url :%@",url);
    }
}

-(void)gotoSVNCommit:(id) sender{
    [PythonConsole SVNCommit:NULL];
}

-(void)gotoSvnCommitWithLog:(id) sender{
    CommitWithLogController *controller = [[CommitWithLogController alloc] initWithWindowNibName :@"CommitWithLogController"];
    controller.isGit = NO;
    [controller showWindow:nil];
}

-(void)gotoSVNUpdate:(id) sender{
    [PythonConsole SVNUpdate];
}

-(void)gotoSVNLog:(id) sender{
    [PythonConsole SVNLog];
}

-(void)gotoSVNAdd:(id) sender{
    [PythonConsole SVNAdd];
}

-(void)gotoConfig:(id) sender{
    ConfigController *controller = [[ConfigController alloc] initWithWindowNibName :@"ConfigController"];
    [controller showWindow:nil];
}


-(void)gotoSqliteHelper:(id) sender{
    SqliteController *controller = [[SqliteController alloc] initWithWindowNibName :@"SqliteController"];
    [controller showWindow:nil];
}

-(void)gotoRegexConsole:(id) sender{
    RegexController *controller = [[RegexController alloc] initWithWindowNibName :@"RegexController"];
    [controller showWindow:nil];
}


-(void)gotoAboutPlugin:(id) sender{
    AboutPluginController *controller = [[AboutPluginController alloc] initWithWindowNibName :@"AboutPluginController"];
    [controller showWindow:nil];
}

-(void)gotoUninstall:(id) sender {
    //~/Library/Application Support/Developer/Shared/Xcode/Plug-ins
}

-(void)startReplacement:(NSNotification*)notification{
    NSString* replaceStr = notification.object;
    NSLog(@"new value is %@", replaceStr);
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert setMessageText: replaceStr];
    [alert runModal];
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"start_replace" object:nil];
}

-(void)notificationListener:(NSNotification *)noti {
    NSLog(@"  Notification: %@", [noti name]);
}


@end


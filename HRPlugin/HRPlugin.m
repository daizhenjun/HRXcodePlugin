//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import "HRPlugin.h"
#import "AboutPluginController.h"
#import "DZTools.h"
#import "PythonConsole.h"
#import "Serializer.h"
#import "ConfigController.h"
#import "CommitWithLogController.h"
#import "SqliteController.h"
#import "RegexController.h"
#import "NSMenuBlockActionExtension.h"
#import "HttpProxyController.h"

@interface HRPlugin()
@property (nonatomic,retain) NSString *selectedText;
@end

@implementation HRPlugin


+ (void) pluginDidLoad: (NSBundle*) plugin {
    NSLog(@"HRPlugin");
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
	}
	return self;
}


-(void) addSearchMenu{
    //add google search
    NSMenuItem *googleSearch = [[[NSMenuItem alloc] initWithTitle:@"Google Search" action:@selector(gotoSearch:) keyEquivalent:@""] autorelease];
    [googleSearch setTarget:self];
    [newMenu addItem:googleSearch];
   
    //add baidu search
    NSMenuItem *baiduSearch = [[[NSMenuItem alloc] initWithTitle:@"Baidu Search" action:@selector(gotoSearch:) keyEquivalent:@""] autorelease];
    [baiduSearch setTarget:self];
    [newMenu addItem:baiduSearch];
    
    //add splitter
    [newMenu addItem:[NSMenuItem separatorItem]];
}




-(void) addSVNMenu{
    NSMenuItem *svnCommit = [[[NSMenuItem alloc] initWithTitle:@"SVN Commit" action:@selector(gotoSVN:) keyEquivalent:@""] autorelease];
    [svnCommit setTarget:self];
    [newMenu addItem:svnCommit];
    
    NSMenu *svnCommitMenu = [[[NSMenu allocWithZone:[NSMenu menuZone]]
                             init] autorelease];
    NSMenuItem *svnCommitWithLog = [[[NSMenuItem alloc] initWithTitle:@"Commit With Log" action:@selector(gotoSVN:) keyEquivalent:@""] autorelease];
    [svnCommitWithLog setTarget:self];
    [svnCommitMenu addItem:svnCommitWithLog];
    [svnCommit setSubmenu: svnCommitMenu];
    
    
    NSMenuItem *svnUpdate = [[[NSMenuItem alloc] initWithTitle:@"SVN Update" action:@selector(gotoSVN:) keyEquivalent:@""] autorelease];
    [svnUpdate setTarget:self];
    [newMenu addItem:svnUpdate];
    
    NSMenuItem *svnLog = [[[NSMenuItem alloc] initWithTitle:@"SVN Log" action:@selector(gotoSVN:) keyEquivalent:@""] autorelease];
    [svnLog setTarget:self];
    [newMenu addItem:svnLog];
    
    NSMenuItem *svnAdd = [[[NSMenuItem alloc] initWithTitle:@"SVN Add" action:@selector(gotoSVN:) keyEquivalent:@""] autorelease];
    [svnAdd setTarget:self];
    [newMenu addItem:svnAdd];
    
    //add splitter
    [newMenu addItem:[NSMenuItem separatorItem]];
}

-(void) addGitMenu{
    NSMenuItem *gitCommit = [[[NSMenuItem alloc] initWithTitle:@"Git Commit" action:@selector(gotoGit:) keyEquivalent:@""] autorelease];
    [gitCommit setTarget:self];
    [newMenu addItem:gitCommit];
    
    NSMenu *gitCommitMenu = [[[NSMenu allocWithZone:[NSMenu menuZone]]
                             init] autorelease];
    NSMenuItem *gitCommitWithLog = [[[NSMenuItem alloc] initWithTitle:@"Commit With Log" action:@selector(gotoGit:) keyEquivalent:@""] autorelease];
    [gitCommitWithLog setTarget:self];
    [gitCommitMenu addItem:gitCommitWithLog];
    [gitCommit setSubmenu: gitCommitMenu];
    
    NSMenuItem *gitPull = [[[NSMenuItem alloc] initWithTitle:@"Git Pull" action:@selector(gotoGit:) keyEquivalent:@""] autorelease];
    [gitPull setTarget:self];
    [newMenu addItem:gitPull];
    
    NSMenuItem *svnStatus = [[[NSMenuItem alloc] initWithTitle:@"Git Status" action:@selector(gotoGit:) keyEquivalent:@""]  autorelease];
    [svnStatus setTarget:self];
    [newMenu addItem:svnStatus];
    
    NSMenuItem *gitAdd = [[[NSMenuItem alloc] initWithTitle:@"Git Add" action:@selector(gotoGit:) keyEquivalent:@""] autorelease];
    [gitAdd setTarget:self];
    [newMenu addItem:gitAdd];
    
    //add splitter
    [newMenu addItem:[NSMenuItem separatorItem]];
}

-(void) addSqliteMenu{
    NSMenuItem *sqlite = [[[NSMenuItem alloc] initWithTitle:@"Sqlite Helper" action:@selector(gotoSqliteHelper:) keyEquivalent:@""] autorelease];
    [sqlite setTarget:self];
    [newMenu addItem:sqlite];
    
    //add splitter
    [newMenu addItem:[NSMenuItem separatorItem]];
}

-(void) addRegexMenu{
    NSMenuItem *regexConsole = [[[NSMenuItem alloc] initWithTitle:@"Regex Console" action:@selector(gotoRegexConsole:) keyEquivalent:@""] autorelease];
    [regexConsole setTarget:self];
    [newMenu addItem:regexConsole];
    
    //add splitter
    [newMenu addItem:[NSMenuItem separatorItem]];
}

-(void) addHttpProxyMenu{
    NSMenuItem *proxyConsole = [[[NSMenuItem alloc] initWithTitle:@"Http Proxy" action:@selector(gotoHttpProxyConsole:) keyEquivalent:@""] autorelease];
    [proxyConsole setTarget:self];
    [newMenu addItem:proxyConsole];
    
    //add splitter
    [newMenu addItem:[NSMenuItem separatorItem]];
}

-(void) addOtherMenu{
    //add config menu
    NSMenuItem *saveConfig = [[[NSMenuItem alloc] initWithTitle:@"Save Config" action:@selector(gotoConfig:) keyEquivalent:@""] autorelease];
    [saveConfig setTarget:self];
    [newMenu addItem:saveConfig];
    
    //add about menu
    NSMenuItem *aboutPlugin = [[[NSMenuItem alloc] initWithTitle:@"About Plugin" action:@selector(gotoAboutPlugin:) keyEquivalent:@""] autorelease];
    [aboutPlugin setTarget:self];
    [newMenu addItem:aboutPlugin];
    
    //add Uninstall menu
    NSMenuItem *uninstall = [[[NSMenuItem alloc] initWithTitle:@"Uninstall" action:@selector(gotoUninstall:) keyEquivalent:@""] autorelease];
    [uninstall setTarget:self];
    [newMenu addItem:uninstall];
}

- (void) initPlugInMenu{
    //Test
    //    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    //    if (editMenuItem) {
    //        [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
    //
    //        NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:@"Google Search" action:@selector(showSelected:) keyEquivalent:@""];
    //
    //        [newMenuItem setTarget:self];
    //        [newMenuItem setKeyEquivalentModifierMask: NSAlternateKeyMask];
    //        [[editMenuItem submenu] addItem:newMenuItem];
    //        [newMenuItem release];
    //    }
    
    //添加菜单参见https://github.com/Dwarfartisan/BlackCookbook/blob/master/objc/statusmenu/MainMenu.m
    newMenu  = [[NSMenu allocWithZone:[NSMenu menuZone]]
                        initWithTitle:@"HR-Plugin"];
    NSMenuItem *newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
                           initWithTitle:@"HR-Plugin" action:NULL keyEquivalent:@""];
    
    [self addSearchMenu];
    [self addSVNMenu];
    [self addGitMenu];
    [self addSqliteMenu];
    [self addRegexMenu];
    [self addHttpProxyMenu];
    [self addOtherMenu];
    //
    [newItem setSubmenu:newMenu];
    [newMenu release];
    [[NSApp mainMenu] addItem:newItem];
    [newItem release];
}

- (void) applicationDidFinishLaunching: (NSNotification*) noti {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectionDidChange:)
                                                 name:NSTextViewDidChangeSelectionNotification
                                               object:nil];
    [self initPlugInMenu];
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


-(void)gotoSearch:(id) sender{
    if([DZTools isValidString:self.selectedText]){
        NSString *searchText = [self.selectedText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *url;
        if([((NSMenuItem*)sender).title hasPrefix:@"Google" ]){
            url = [NSString stringWithFormat:@"http://www.google.com.hk/search?q=stackoverflow+%@",searchText];
            NSLog(@"google url :%@",url);
        }else{
            url = [NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",searchText];
            NSLog(@"baidu url :%@",url);
        }
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
    }
}

-(void)gotoSVN:(id) sender{
    NSString *title = ((NSMenuItem*)sender).title;
    if([title isEqualToString:@"SVN Commit"]){
        [PythonConsole SVNCommit:NULL];
    }else if([title isEqualToString:@"Commit With Log"]){
        CommitWithLogController *controller = [[CommitWithLogController alloc] initWithWindowNibName :@"CommitWithLogController"];
        controller.isGit = NO;
        [controller showWindow:nil];
    }else if([title isEqualToString:@"SVN Update"]){
        [PythonConsole SVNUpdate];
    }else if([title isEqualToString:@"SVN Log"]){
        [PythonConsole SVNLog];
    }else if([title isEqualToString:@"SVN Add"]){
        [PythonConsole SVNAdd];
    }
}

-(void)gotoGit:(id) sender{
    NSString *title = ((NSMenuItem*)sender).title;
    if([title isEqualToString:@"Git Commit"]){
        [PythonConsole GitCommit:NULL];
    }else if([title isEqualToString:@"Commit With Log"]){
        CommitWithLogController *controller = [[CommitWithLogController alloc] initWithWindowNibName :@"CommitWithLogController"];
        controller.isGit = YES;
        [controller showWindow:nil];
    }else if([title isEqualToString:@"Git Pull"]){
        [PythonConsole GitPull];
    }else if([title isEqualToString:@"Git Status"]){
        [PythonConsole GitStatus];
    }else if([title isEqualToString:@"Git Add"]){
        [PythonConsole GitAdd];
    }
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

-(void)gotoHttpProxyConsole:(id) sender{
    HttpProxyController *controller = [[HttpProxyController alloc] initWithWindowNibName :@"HttpProxyController"];
    [controller showWindow:nil];
}


-(void)gotoAboutPlugin:(id) sender{
    AboutPluginController *controller = [[AboutPluginController alloc] initWithWindowNibName :@"AboutPluginController"];
    [controller showWindow:nil];
}

-(void)gotoUninstall:(id) sender {
    NSAlert *alert = [NSAlert alertWithMessageText:@"出大事了!"
                                     defaultButton:@"删除 :("
                                   alternateButton:@"取消 :)"
                                       otherButton:nil
                         informativeTextWithFormat:@"亲, 真的要删除这个如此逆天的插件吗?"];
     if ( [alert runModal] == NSOKButton ){ 
          NSFileManager *fileManager= [NSFileManager defaultManager];
          BOOL isDir = NO;
          const char *homeDir = getenv("HOME");
          
          if (homeDir){
              NSString *directory = [NSString stringWithFormat:@"%@/Library/Application Support/Developer/Shared/Xcode/Plug-ins/HRXCodePlugin.xcplugin/", [NSString stringWithUTF8String:homeDir]];
             if([fileManager fileExistsAtPath:directory isDirectory:&isDir]) {
                if(isDir){
                    @try {
                        [fileManager removeItemAtPath:directory error:nil];
                        NSLog(@"删除当前插件： %@", directory);
                        [PythonConsole showMessage:@"插件已删除,需重启XCode后才会生效!"];
                    }
                    @catch (NSException *exception) {
                        [PythonConsole showMessage:@"删除插件失败!"];
                    }
                }
            } else{
                [PythonConsole showMessage:@"插件已删除,需重启XCode后才会生效!"];
            }
         }
     }
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

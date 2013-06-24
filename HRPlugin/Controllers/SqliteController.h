//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import <Cocoa/Cocoa.h>

@interface SqliteController : NSWindowController<NSOutlineViewDataSource, NSOutlineViewDelegate, NSTableViewDataSource,NSTableViewDelegate>{
    //http://www.alauda.ro/2012/04/30/nsoutlineview-inside-out/
    IBOutlet NSOutlineView *myOutlineView;
    IBOutlet NSTableView *searchResultView;
    NSMutableArray *searchResultArray;
    NSMutableDictionary *tableSqlDic;
    NSMutableArray *list;
}

@property (nonatomic, retain) IBOutlet NSTextField *dbPath;
@property (nonatomic, retain) IBOutlet NSTextField *sqlText;
@property (nonatomic, retain) IBOutlet NSButton *browserButton;
@property (nonatomic, retain) IBOutlet NSButton *runSQL;
@property (nonatomic, retain) IBOutlet NSMenu *outlineViewContextMenu;


-(IBAction)browerClick:(id)sender;
-(IBAction)runSqlClick:(id)sender;
-(IBAction)printTableSqlClick:(id)sender;
-(IBAction)generateObjectCCodeClick:(id)sender;
-(IBAction)generateCSharpCodeClick:(id)sender;
-(IBAction)generateJavaCodeClick:(id)sender;
@end



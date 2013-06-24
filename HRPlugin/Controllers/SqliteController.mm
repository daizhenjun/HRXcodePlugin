//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import "SqliteController.h"
#import "Serializer.h"
#import "DZTools.h"
#include "SQLiteHelper.h"
#include "DBHelper.h"
#include "PythonConsole.h"
#include <iostream>
#include "CodeGenerator.h"
@interface SqliteController ()

@end

@implementation SqliteController

using namespace SQLiteWrapper;
using namespace std;

DB db;
NSMutableDictionary *tableColumns;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        list = [[NSMutableArray alloc] init];
        tableSqlDic = [[NSMutableDictionary alloc] init];
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(outlineViewSelectionDidChange:)
                       name:@"NSOutlineViewSelectionDidChangeNotification"
                     object:myOutlineView];        
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    CommonConfig *config = [CommonConfig get:COMMON_CONFIG_KEY];
    if(config == nil || ![DZTools isValidString:config.dbPath]){
        [self browerClick:nil];
    }else{
        [self.dbPath setStringValue: [NSString stringWithFormat:@"db-path: %@", config.dbPath]];
        [self loadDBFile:config.dbPath];
    }
}

-(IBAction)browerClick:(id)sender{
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ApplicationKit/Classes/NSOpenPanel_Class/Reference/Reference.html
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setTitle:@"SQLite数据库或路径"];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:YES];
    
    if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton ){
        NSArray* files = [openDlg filenames];
        if([files count] > 0){
            [self loadDBFile:[files objectAtIndex:0]];
        }
    }
}

- (void)loadTables{
    try{
        //http://blog.csdn.net/yuxiayiji/article/details/8426280
        Table table = db.getTable("select * from sqlite_master WHERE type = 'table'");
        [list removeAllObjects];
        [tableSqlDic removeAllObjects];
        for (int row = 0; row < table.rowsCount(); row++){
            Row r= table.getRow(row);
            NSString *tableName = [[NSString alloc] initWithCString:(const char*)r[1]
                                                           encoding:NSUTF8StringEncoding];
            NSString *tableStruct = [[NSString alloc] initWithCString:(const char*)r[4]
                                                             encoding:NSUTF8StringEncoding];
            NSDictionary* tableDic = [[NSDictionary alloc] initWithObjectsAndKeys:tableName,@"parent",
                                      [CodeGenerator getTableFiles:tableStruct] ,@"children", nil];
            [list addObject:tableDic];
            [tableSqlDic setObject:[[NSString alloc] initWithCString:(const char*)r[4]
                                                            encoding:NSUTF8StringEncoding] forKey:tableName];
        }
        [myOutlineView reloadData];
    }catch (CppSQLite3Exception e) {
        [PythonConsole showMessage: [[NSString alloc] initWithCString:e.errorMessage()
                                                             encoding:NSUTF8StringEncoding]];
    }
}

- (void)loadDBFile:(NSString*) dbPath {
    BOOL loadFlag = NO;
    BOOL isDir = NO;
    NSFileManager *manager = [NSFileManager defaultManager];
    try{
        if([manager fileExistsAtPath:dbPath isDirectory:&isDir]){//如果是文件
            if(isDir == YES){//如果是文件夹
                dbPath = [NSString stringWithFormat: @"%@/sample.db",  dbPath];
                initTestDB(dbPath);
            }
            std::string dbpathstr =[dbPath UTF8String];
            db.open(dbpathstr.c_str());
            loadFlag= YES;
            [self loadTables];
        }
    }catch (CppSQLite3Exception e) {
        [PythonConsole showMessage: [[NSString alloc] initWithCString:e.errorMessage()
                                                             encoding:NSUTF8StringEncoding]];
    }
    if(loadFlag == YES){
        CommonConfig *config = [CommonConfig get:COMMON_CONFIG_KEY];
        config.dbPath = dbPath;
        [config set:COMMON_CONFIG_KEY];
        [self.dbPath setStringValue: [NSString stringWithFormat:@"db-path: %@", dbPath]];
    }else{
        [PythonConsole  showMessage:@"数据库加载失败!"];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item isKindOfClass:[NSDictionary class]] || [item isKindOfClass:[NSArray class]]) {
        return YES;
    }else {
        return NO;
    }
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [list count];
    }
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [[item objectForKey:@"children"] count];
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [list objectAtIndex:index];
    }
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [[item objectForKey:@"children"] objectAtIndex:index];
    }
    return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)theColumn byItem:(id)item
{
    if ([item isKindOfClass:[NSDictionary class]]){
        NSCell * cell = (NSCell *) [item objectForKey:@"parent"];
        //[cell setMenu:[self outlineViewContextMenu]];
        return cell;//[item objectForKey:@"parent"];
    }else{
        return item;
    }
}

NSString *selectedTableName = nil;

-(void)outlineViewSelectionDidChange:(NSNotification*)notification{
    NSString* selectedItem = [NSString stringWithFormat:@"%@", [myOutlineView itemAtRow:[myOutlineView selectedRow]]];
    NSLog(@"%@", selectedItem);
    NSRange xrange=[selectedItem rangeOfString:@"parent = "];//is parent node?
    if(xrange.length>0){
        NSString *selectedTable = [selectedItem substringFromIndex:xrange.location + 9];
        selectedTable = [selectedTable substringToIndex:[selectedTable length]-3];//remove last ";}"
        selectedTableName = [selectedTable copy];
        //[PythonConsole  showMessage:selectedTableName];
        [self.sqlText setStringValue: [NSString stringWithFormat:@"select * from %@", selectedTable]];
    }
}


-(IBAction)printTableSqlClick:(id)sender{
    if([DZTools isValidString:selectedTableName]){
        //[PythonConsole  showMessage:selectedTableName];
        [self.sqlText setStringValue:[tableSqlDic objectForKey:selectedTableName]];
    }
}


-(NSString*) getSelectSqlText{
    NSText *textEditor = [self.sqlText currentEditor];
    NSArray* selectedRanges = [textEditor selectedRanges];
    if ( [[selectedRanges objectAtIndex:0] rangeValue].length==0) {
        return [self.sqlText stringValue];
    }
    NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
    return [[self.sqlText stringValue] substringWithRange:selectedRange];
}

-(void) execSql:(NSString*) sql{
    if([sql hasPrefix:@"select"]){
        [self removeDynamicColumns];
        Table table = db.getTable([sql UTF8String]);
        //load columns
        tableColumns = [[NSMutableDictionary alloc] init];
        for (int fld = 0; fld < table.fieldsCount(); fld++)
        {
            NSString *fieldName = [[NSString alloc] initWithCString:(const char*)table.fieldName(fld) encoding:NSUTF8StringEncoding];
            [self addDynamicColumn:fieldName  columnNum:fld];
            [tableColumns  setObject:[NSNumber numberWithInt:fld] forKey:fieldName];
            NSLog(@"column %@", fieldName);
        }
        searchResultArray = [[NSMutableArray alloc] init];
        NSLog(@"rows %i", table.rowsCount());
        
        for (int row = 0; row < table.rowsCount(); row++){
            Row r= table.getRow(row);
            NSMutableArray* _row = [[NSMutableArray alloc] init];
            for(int fld = 0; fld < table.fieldsCount(); fld++){
                if(r[fld] != NULL) {
                    NSString *value = [[NSString alloc] initWithCString:(const char*)r[fld]
                                                               encoding:NSUTF8StringEncoding];
                    [_row addObject: value];//[PythonConsole showMessage: value];
                } else{
                    [_row addObject: @"null"];
                }
            }
            [searchResultArray addObject:_row];
        }
        [searchResultView setNeedsDisplay:YES];
        [searchResultView reloadData];
    }else{
        db.execNoQuery([sql UTF8String]);
    }

}

-(IBAction)runSqlClick:(id)sender{
    NSString *sqls = [self getSelectSqlText];
    if([DZTools isValidString:sqls]){
        for(NSString * sql in [sqls componentsSeparatedByString:@";"]){
            try {
                sql = [sql stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if([DZTools isValidString:sql]){
                    [self execSql:sql];
                }
            }
            catch (CppSQLite3Exception e) {
                [PythonConsole showMessage: [[NSString alloc] initWithCString:e.errorMessage()
                                                                    encoding:NSUTF8StringEncoding]];
            }
        }
    }
}


/**************************tableview******************************/

#pragma mark - TableViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [searchResultArray count];
}

- (id) tableView:(NSTableView *)pTableViewObj objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(NSInteger)pRowIndex {
    NSMutableArray* record = [searchResultArray objectAtIndex:pRowIndex];
    NSNumber *columnIndex = (NSNumber*)[tableColumns objectForKey:[pTableColumn identifier]];
    if(columnIndex >=0){
        return [record objectAtIndex:(NSUInteger)[columnIndex intValue]];
    }else{
        return NULL;
    }
                              
}

- (void)tableView:(NSTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (CGFloat)tableView:(NSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 64.0f;
}

- (void)addDynamicColumn:(NSString*) columnName  columnNum:(NSInteger)columnNum
{
    NSTableColumn* column = [self createTableColumnWithIdentifier:columnName title:columnName];
    [searchResultView addTableColumn:column];
    [column release];
}

- (void)removeDynamicColumns
{
    NSInteger count = [[searchResultView tableColumns] count];
    for(int i = 0; i < count; i++){
        NSTableColumn* column = [[searchResultView tableColumns] objectAtIndex:0];
        [searchResultView removeTableColumn:column];
    }
}

- (NSTableColumn*)createTableColumnWithIdentifier:(NSString*)
columnIdentifier title:(NSString*)columnTitle
{
    NSTableColumn* column = [[NSTableColumn alloc]initWithIdentifier:columnIdentifier];
    [column setEditable:NO];
    [[column headerCell] setStringValue:columnTitle];
    return column;
}

-(IBAction)generateObjectCCodeClick:(id)sender{
    if([DZTools isValidString:selectedTableName]){
        //[PythonConsole  showMessage:selectedTableName];
        [self.sqlText setStringValue:[CodeGenerator generateForObjectC:selectedTableName
                                                           tableFields:[tableSqlDic objectForKey:selectedTableName]]];
    }
}


-(IBAction)generateCSharpCodeClick:(id)sender{
    if([DZTools isValidString:selectedTableName]){
        //[PythonConsole  showMessage:selectedTableName];
        [self.sqlText setStringValue:[CodeGenerator generateForCSharp:selectedTableName
                                                          tableFields:[tableSqlDic objectForKey:selectedTableName]]];
    }
}

-(IBAction)generateJavaCodeClick:(id)sender{
    if([DZTools isValidString:selectedTableName]){
        //[PythonConsole  showMessage:selectedTableName];
        [self.sqlText setStringValue:[CodeGenerator generateForJava:selectedTableName
                                                        tableFields:[tableSqlDic objectForKey:selectedTableName]]];
    }
}

@end

//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军
//

#ifndef MyNavSample_DBHelper_h
#define MyNavSample_DBHelper_h

#import "SQLiteHelper.h"
//#import "PythonConsole.h"

#include <ctime>
#include <iostream>

using namespace std;
using namespace SQLiteWrapper;
//namespace SQLiteWrapper {
//class DBHelper
//{
//    
//       
//private:
//    DBHelper()
//    {}
//    virtual ~DBHelper(void)
//    {}
//    
//public:
//    static DB db;
//    static int intvalue;
// 
//    static DB loadDb()
//    {
//        DB database;
//        {
//            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory/*NSCachesDirectory*/, NSUserDomainMask, YES);
//            NSString *path = @"/Users/daizhenjun/Desktop/sqlite_test.db";
//            
//            // create directory for db if it not exists
//            NSFileManager *fileManager = [[NSFileManager alloc] init];
//            BOOL isDirectory = NO;
//            BOOL exists = [fileManager  fileExistsAtPath:path isDirectory:&isDirectory];
//            if (!exists) {
//                [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
//                if (![fileManager fileExistsAtPath:path]) {
//                    [NSException raise:@"FailedToCreateDirectory" format:@"Failed to create a directory for the db at '%@'",path];
//                }
//            }
//            [fileManager release];
//            // create db object
//            NSString *dbfilePath = [path stringByAppendingPathComponent:@"Blogs"];
//            std::string dbpathstr =[dbfilePath UTF8String];
//            
//            
//            const char *dbpath = dbpathstr.c_str();//"/Users/MySqlLitePath/Blogs";
//            database.open(dbpath);
//            [pool release];
//        }
//        return database;
//
//    }
//    
//    
//    static bool tableExists(const char* szTable)
//    {
//       return db.tableExists(szTable);
//    }
//    
//       
//    static int execNoQuery(const char* szSQL)
//    {
//        return db.execDML(szSQL);
//    }
//    
//    static Query execQuery(const char* szSQL)
//    {
//        return db.execQuery(szSQL);
//    }
//    
//    static int execScalar(const char* szSQL)
//    {
//        return db.execScalar(szSQL);
//    }
//    
//    static Table getTable(const char* szSQL)
//    {
//        return db.getTable(szSQL);
//    }
//    
//    static Statement compileStatement(const char* szSQL)
//    {
//        return db.compileStatement(szSQL);
//    }
//    
//    static sqlite_int64 lastRowId()
//    {
//        return db.lastRowId();
//    }
//    
//   
//    static void setBusyTimeout(int nMillisecs)
//    {
//        db.setBusyTimeout(nMillisecs);
//    } 
//       
//};
//}


using namespace SQLiteWrapper;

//DB DBHelper::db = DBHelper::loadDb();


void initTestDB(NSString * dbpath){
    DB database;
    {
        std::string dbpathstr =[dbpath UTF8String];
        const char * path = dbpathstr.c_str();
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        database.open(path);
      
        //创建测试表
        if(database.tableExists("student")){
            database.execNoQuery("drop table student;");
        }
        database.execNoQuery("create table student (id int, name char(20), age short, grade short);");
        database.execNoQuery("insert into student values (1, '张三', 3, 4);");
        database.execNoQuery("insert into student values (1, '李四', 3, 5);");
        
        if(database.tableExists("teacher")){
            database.execNoQuery("drop table teacher;");
        }
        database.execNoQuery("create table teacher (id int, name char(20));");
        database.execNoQuery("insert into teacher values (1, '老师1');");
        database.execNoQuery("insert into teacher values (1, '老师2');");
        database.close();
        [pool release];
    }
}

//int SqlLiteDBHelperDemo()
//{
//    try
//    {
//        cout << endl << "emp table exists=" << (DBHelper::tableExists("emp") ? "TRUE":"FALSE") << endl;
//        cout << endl << "Creating emp table" << endl;
//        if(DBHelper::tableExists("emp")){
//            DBHelper::execNoQuery("drop table emp;");
//        }
//        
//
//        if(DBHelper::tableExists("student")){
//            DBHelper::execNoQuery("drop table student;");
//        }
//
//        DBHelper::execNoQuery("create table student(studentid int, studentname char(20), studentage int);");
//        DBHelper::execNoQuery("insert into student values (1, 'David 1', 3);");
//        DBHelper::execNoQuery("insert into student values (2, 'David 2', 4);");
//        DBHelper::execNoQuery("create table emp(empno int, empname char(20));");   
//        cout << endl << "emp table exists=" << (DBHelper::tableExists("emp") ? "TRUE":"FALSE") << endl;
//        ////////////////////////////////////////////////////////////////////////////////
//        // Execute some DML, and print number of rows affected by each one
//        ////////////////////////////////////////////////////////////////////////////////
//        cout << endl << "DML tests" << endl;
//        int nRows = DBHelper::execNoQuery("insert into emp values (7, 'David Beckham');");
//        cout << nRows << " rows inserted" << endl;
//        
//        nRows = DBHelper::execNoQuery("update emp set empname = 'Christiano Ronaldo' where empno = 7;");
//        cout << nRows << " rows updated" << endl;
//        
//        nRows = DBHelper::execNoQuery("delete from emp where empno = 7;");
//        cout << nRows << " rows deleted" << endl;
//        
//        ////////////////////////////////////////////////////////////////////////////////
//        // Transaction Demo
//        // The transaction could just as easily have been rolled back
//        ////////////////////////////////////////////////////////////////////////////////
//        int nRowsToCreate(8);
//        cout << endl << "Transaction test, creating " << nRowsToCreate;
//        cout << " rows please wait..." << endl;
//        
//        DBHelper::execNoQuery("begin transaction;");
//        
//        for (int i = 0; i < nRowsToCreate; i++)
//        {
//            char buf[128];
//            sprintf(buf, "insert into emp values (%d, 'Empname%06d');", i, i);
//            DBHelper::execNoQuery(buf);
//        }
//        
//        DBHelper::execNoQuery("commit transaction;");
//        
//        ////////////////////////////////////////////////////////////////////////////////
//        // Demonstrate CppSQLiteDB::execScalar()
//        ////////////////////////////////////////////////////////////////////////////////
//        cout << DBHelper::execScalar("select count(*) from emp;") << " rows in emp table in ";
//        
//        
//        ////////////////////////////////////////////////////////////////////////////////
//        // Re-create emp table with auto-increment field
//        ////////////////////////////////////////////////////////////////////////////////
//        cout << endl << "Auto increment test" << endl;
//        DBHelper::execNoQuery("drop table emp;");
//        DBHelper::execNoQuery("create table emp(empno integer primary key, empname char(20));");
//        cout << nRows << " rows deleted" << endl;
//        
//        for (int i = 0; i < 5; i++)
//        {
//            char buf[128];
//            sprintf(buf, "insert into emp (empname) values ('Empname%06d');", i+1);
//            DBHelper::execNoQuery(buf);
//            cout << " primary key: " << (int)DBHelper::lastRowId() << endl;
//        }
//        
//        ////////////////////////////////////////////////////////////////////////////////
//        // Query data and also show results of inserts into auto-increment field
//        ////////////////////////////////////////////////////////////////////////////////
//        cout << endl << "Select statement test" << endl;
//        Query q = DBHelper::execQuery("select * from emp order by 1;");
//        
//        for (int fld = 0; fld < q.fieldsCount(); fld++)
//        {
//            cout << q.fieldName(fld) << "(" << q.fieldDeclType(fld) << ")|";
//        }
//        cout << endl;
//        
//        while (!q.eof())
//        {
//            //            cout << q.fieldValue(0) << "|" ;
//            //            cout << q.fieldValue(1) << "|" << endl;
//            //            
//            //            cout << q.fieldValue("empno") << "||" ;
//            //            cout << q.fieldValue("empname") << "||" << endl;
//            //as same as follow:
//            cout << q[0] << "|" ;
//            cout << q[1] << "|" << endl;
//            
//            cout << q["empno"] << "||" ;
//            cout << q["empname"] << "||" << endl;
//       
//           // NSAlert *alert = [[[NSAlert alloc] init] autorelease];
//            //当有错误提示时
////            NSString *empname = [[NSString alloc] initWithCString:(const char*)q["empname"] encoding:NSUTF8StringEncoding];
////            [alert setMessageText: empname];
////            [alert runModal];
//            q.nextRow();
//        }
//        
//        
//        ////////////////////////////////////////////////////////////////////////////////
//        // SQLite's printf() functionality. Handles embedded quotes and NULLs
//        ////////////////////////////////////////////////////////////////////////////////
//        cout << endl << "SQLite sprintf test" << endl;
//        Buffer bufSQL;
//        bufSQL.format("insert into emp (empname) values (%Q);", "He's bad");
//        cout << (const char*)bufSQL << endl;
//        DBHelper::execNoQuery(bufSQL);
//        DBHelper::execNoQuery(bufSQL);
//        
////        bufSQL.format("insert into emp (empname) values (%Q);", NULL);
////        cout << (const char*)bufSQL << endl;
////        DBHelper::execNoQuery(bufSQL);
//        
//        ////////////////////////////////////////////////////////////////////////////////
//        // Fetch table at once, and also show how to use CppSQLiteTable::setRow() method
//        ////////////////////////////////////////////////////////////////////////////////
//        cout << endl << "getTable() test" << endl;
//        Table t = DBHelper::getTable("select * from emp order by 1;");
//        
//        for (int fld = 0; fld < t.fieldsCount(); fld++)
//        {
//            cout << t.fieldName(fld) << "|";
//        }
//        cout << endl;
//        for (int row = 0; row < t.rowsCount(); row++)
//        {
//            //           t.setRow(row);
//            //            for (int fld = 0; fld < t.numFields(); fld++)
//            //            {
//            //                if (!t.fieldIsNull(fld))
//            //                    cout << t[fld] << "|";//cout << t.fieldValue(fld) << "|";
//            //                else
//            //                    cout << "NULL" << "|";
//            //            }
//            //            cout << t["empno"] << " " << t["empname"] << "|";
//            
//            Row r= t.getRow(row);
//            cout << r["empno"] << " " << r["empname"] << "|";
//            
//            cout << endl;
//        }
//        
//        
//        ////////////////////////////////////////////////////////////////////////////////
//        // Test CppSQLiteBinary by storing/retrieving some binary data, checking
//        // it afterwards to make sure it is the same
//        ////////////////////////////////////////////////////////////////////////////////
////        cout << endl << "Binary data test" << endl;
////        DBHelper::execNoQuery("create table bindata(desc char(10), data blob);");////在IPAD会造成错误
////        
////        unsigned char bin[256];
////        Binary blob;
////        
////        for (int i = 0; i < sizeof bin; i++)
////        {
////            bin[i] = i;
////        }
////        
////        blob.setBinary(bin, sizeof bin);
////        
////        bufSQL.format("insert into bindata values ('testing', %Q);", blob.getEncoded());
////        DBHelper::execNoQuery(bufSQL);
////        cout << "Stored binary Length: " << sizeof bin << endl;
////        
////        q = DBHelper::execQuery("select data from bindata where desc = 'testing';");
////        
////        if (!q.eof())
////        {
////            blob.setEncoded((unsigned char*)q.fieldValue("data"));
////            cout << "Retrieved binary Length: " << blob.getBinaryLength() << endl;
////        }
////		q.finalize();
////        
////        const unsigned char* pbin = blob.getBinary();
////        for (int i = 0; i < sizeof bin; i++)
////        {
////            if (pbin[i] != i)
////            {
////                cout << "Problem: i: ," << i << " bin[i]: " << pbin[i] << endl;
////            }
////        }
//        
//        
//		////////////////////////////////////////////////////////////////////////////////
//        // Pre-compiled Statements Demo
//        ////////////////////////////////////////////////////////////////////////////////
//        cout << endl << "Transaction test, creating " << nRowsToCreate;
//        cout << " rows please wait..." << endl;
//        DBHelper::execNoQuery("drop table emp;");
//        DBHelper::execNoQuery("create table emp(empno int, empname char(20));");
//        
//        DBHelper::execNoQuery("begin transaction;");
//        
//        Statement stmt = DBHelper::compileStatement("insert into emp values (?, ?);");
//        for (int i = 0; i < nRowsToCreate; i++)
//        {
//            char buf[16];
//            sprintf(buf, "EmpName%06d", i);
//            stmt.bind(1, i);
//            stmt.bind(2, buf);
//            stmt.execDML();
//            stmt.reset();
//        }
//        
//        DBHelper::execNoQuery("commit transaction;");
//        
//        
//        cout << DBHelper::execScalar("select count(*) from emp;") << " rows in emp table in ";
//        
//        cout << endl << "End of tests" << endl;
//    }
//    catch (CppSQLite3Exception& e)
//    {
//        cout << e.errorCode() << e.errorMessage() << endl;
//        cerr << e.errorCode() << ":" << e.errorMessage() << endl;
//    }
//    
//    ////////////////////////////////////////////////////////////////////////////////
//    // Loop until user enters q or Q
//    ////////////////////////////////////////////////////////////////////////////////
////    char c(' ');
//    
////    while (c != 'q' && c != 'Q')
////    {
////        cout << "Press q then enter to quit: ";
////        cin >> c;
////    }
//    return 0;
//}

#endif

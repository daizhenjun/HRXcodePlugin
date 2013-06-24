//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军
//

#import <Foundation/Foundation.h>

@interface CodeGenerator : NSObject
+ (NSArray*) getTableFiles:(NSString *)tableStruct;
+(NSString*) generateForObjectC:(NSString *)tableName tableFields:(NSString *)tableFields;
+(NSString*) generateForCSharp:(NSString *)tableName tableFields:(NSString *)tableFields;
+(NSString*) generateForJava:(NSString *)tableName tableFields:(NSString *)tableFields;
@end

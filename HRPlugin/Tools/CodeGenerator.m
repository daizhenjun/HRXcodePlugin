//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import "CodeGenerator.h"
#import "DZTools.h"
#define INDENT @"    "

@implementation CodeGenerator

+ (NSArray*) getTableFiles:(NSString *)tableStruct{
//    NSRange xrange=[tableStruct rangeOfString:@"("];//find first "(" position
//    if(xrange.length>0){
//        tableStruct = [tableStruct substringFromIndex:xrange.location + 1];//spilt from first "("
//        tableStruct = [tableStruct substringToIndex:[tableStruct length]-1];//remove last ")"
//     }
//    NSArray* fields = [tableStruct componentsSeparatedByString:@", "];

    //分解表结构信息
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"(\\()([(\\w)|(\\s)|(\\,)|(\\()]+)"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    __block NSString* tableField = tableStruct;
    [regex enumerateMatchesInString:tableStruct options:0 range:NSMakeRange(0, [tableStruct length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        NSRange matchRange = [match range];
        tableField = [tableField substringFromIndex:matchRange.location + 1];
        tableField = [tableField substringToIndex:matchRange.length-1];
    }];
    
    return [tableField componentsSeparatedByString:@", "];
}

/*********************Object-c 模版变量*********************/
NSString *__include          = @"#import <Foundation/Foundation.h>\n\n";
NSString *__inteface        = @"@interface %@ : NSObject\n";
NSString *__property        = @"@property(nonatomic,assign) %@ %@;\n";
NSString *__end             = @"@end\n\n";
NSString *__import          = @"#import \"%@.h\"\n\n";
NSString *__implementation  = @"@implementation %@\n\n";
NSString *__init            = @"- (id)init "\
                               "{\n"\
                               "    self = [super init];\n"\
                               "    if (self) {\n\n"\
                               "    }\n"\
                               "    return self;\n"\
                               "}\n\n";

NSString *__dealloc         = @"- (id)dealloc "\
                                "{\n"\
                                    "%@\n"\
                                "    [super dealloc];\n"\
                                "    return self;\n"\
                                "}\n\n";

+(NSString*) ObjectcTypeConvert:(NSString*) old{
    if([old hasPrefix:@"int"] || [old hasPrefix:@"short"] ||[old hasPrefix:@"long"]){
        return @"NSNumber";
    }else if([old hasPrefix:@"bool"] || [old hasPrefix:@"bit"]){
        return @"BOOL";
    }else if([old hasPrefix:@"float"] || [old hasPrefix:@"double"]){
        return old;
    }
    else{
        return @"NSString*";
    }
}


+(NSString*) generateForObjectC:(NSString *)tableName tableFields:(NSString *)tableStruct{
    NSArray* fields = [CodeGenerator getTableFiles:tableStruct];
    NSString* result = [NSString stringWithString:__include];
    result = [result stringByAppendingFormat:__inteface, tableName];
    for(NSString* field in fields){
        NSArray* fieldarr = [field componentsSeparatedByString:@" "];
        result = [result stringByAppendingFormat:__property, [CodeGenerator ObjectcTypeConvert:[fieldarr objectAtIndex:1]], [fieldarr objectAtIndex:0]];
    }
    result = [result stringByAppendingFormat:@"%@", __end];
    //接口文件生成完闭
    
    //生成实现文件@implementation
    result = [result stringByAppendingFormat:__implementation, tableName];
    result = [result stringByAppendingFormat:__init, @""];
    
    NSString* __deallocField = @"";
    for(NSString* field in fields){
        NSArray* fieldarr = [field componentsSeparatedByString:@" "];
        __deallocField = [__deallocField stringByAppendingFormat:@"%@self.%@ = nil;\n", INDENT,[fieldarr objectAtIndex:0]];
    }
    result = [result stringByAppendingFormat:__dealloc, __deallocField];
    return [result stringByAppendingFormat:__end, @""];
}


/*********************C# 模版变量*********************/
NSString *__using           = @"using System;\n\n";
NSString *__namespace       = @"namespace Entity\n{\n";
NSString *__className       = @"    public class %@\n    {\n";
NSString *__Description     = @"\n    %@/// <summary>\n"\
                               "    %@/// 描述信息\n"\
                               "    %@/// </summary>\n";
NSString *__fieldPrivate    = @"        private %@ m_%@;	//描述信息\n";
NSString *__fieldPublic     = @"        public %@ %@ \n"\
                               "        {\n"\
                               "            get { return m_%@; }\n"\
                               "            set { m_%@ = value; }\n"\
                               "        }\n";
NSString *__endCSharp       = @"%@}\n";


+(NSString*) CSharpTypeConvert:(NSString*) old{
    if([old hasPrefix:@"bool"] || [old hasPrefix:@"bit"]){
        return @"byte";
    }if([old hasPrefix:@"char"] || [old hasPrefix:@"nchar"]){
        return @"string";
    }else{
        return old;
    }
}


+(NSString*) generateForCSharp:(NSString *)tableName tableFields:(NSString *)tableStruct{
    NSArray* fields = [CodeGenerator getTableFiles:tableStruct];
    NSString* result = [NSString stringWithString: __using];
    result = [result stringByAppendingString: __namespace];
    result = [result stringByAppendingFormat: __Description, @"",@"",@""];
    result = [result stringByAppendingFormat: __className, [DZTools getFirstLetterUpper:tableName]];
    for(NSString* field in fields){
        NSArray* fieldarr = [field componentsSeparatedByString:@" "];
        result = [result stringByAppendingFormat:__fieldPrivate, [CodeGenerator CSharpTypeConvert:[fieldarr objectAtIndex:1]], [fieldarr objectAtIndex:0]];
    }
    
    for(NSString* field in fields){
        result = [result stringByAppendingFormat: __Description, @"    ",@"    ",@"    "];
        NSArray* fieldarr = [field componentsSeparatedByString:@" "];
        NSString* fieldName = [fieldarr objectAtIndex:0];
        NSString* fieldType = [CodeGenerator JavaTypeConvert:[fieldarr objectAtIndex:1]];
        result = [result stringByAppendingFormat:__fieldPublic, fieldType, [DZTools getFirstLetterUpper:fieldName],fieldName,fieldName];
    }
    result = [result stringByAppendingFormat:__endCSharp, INDENT];
    return [result stringByAppendingFormat:__endCSharp, @""];
}


/*********************JAVA 模版变量*********************/
NSString *__package         = @"package model;\n\n";
NSString *__javaImport      = @"import entity;\n\n";
NSString *__javaClassName   = @"public class %@\n{\n";
NSString *__javaDescription = @"/**\n"\
                                "* %@模型\n"\
                                "* @Author:\n"\
                                "* @Date: \n"\
                                "**/\n";
NSString *__javaFieldPrivate= @"    private %@ m_%@;	//描述信息\n";

NSString *__javaGetField    =  @"\n    /**\n"\
                                "    * 描述\n"\
                                "    */\n"\
                                "    public %@ get%@() {\n"\
                                "         return this.m_%@;\n"\
                                "    }\n";

NSString *__javaSetField    =  @"\n    /**\n"\
                                "    * 描述\n"\
                                "    * @param %@:\n"\
                                "    */\n"\
                                "    public void set%@(%@ %@) {\n"\
                                "         this.m_%@ = %@;\n"\
                                "    }\n";
NSString *__endJava       = @"}\n";


+(NSString*) JavaTypeConvert:(NSString*) old{
    if([old hasPrefix:@"bool"] || [old hasPrefix:@"bit"]){
        return @"byte";
    }if([old hasPrefix:@"char"] || [old hasPrefix:@"nchar"]){
        return @"String";
    }else{
        return old;
    }
}


+(NSString*) generateForJava:(NSString *)tableName  tableFields:(NSString *)tableStruct{
    NSArray* fields = [CodeGenerator getTableFiles:tableStruct];
    NSString* result = [NSString stringWithString: __package];
    result = [result stringByAppendingString: __javaImport];
    result = [result stringByAppendingFormat: __javaDescription, tableName];
    result = [result stringByAppendingFormat: __javaClassName, [DZTools getFirstLetterUpper:tableName]];
    for(NSString* field in fields){
        NSArray* arr = [field componentsSeparatedByString:@" "];
        result = [result stringByAppendingFormat:__javaFieldPrivate,
                  [CodeGenerator JavaTypeConvert:[arr objectAtIndex:1]],
                  [arr objectAtIndex:0]];
    }
    
    for(NSString* field in fields){
        NSArray* arr = [field componentsSeparatedByString:@" "];
        NSString* fieldName = [arr objectAtIndex:0];
        NSString* fieldType = [CodeGenerator JavaTypeConvert:[arr objectAtIndex:1]];
        result = [result stringByAppendingFormat: __javaGetField, fieldType,
                  [DZTools getFirstLetterUpper:fieldName],fieldName];
        result = [result stringByAppendingFormat:__javaSetField, fieldName,
                  [DZTools getFirstLetterUpper:fieldName], fieldType, fieldName,fieldName,fieldName];
    }
    return [result stringByAppendingFormat:__endJava, INDENT];
}

@end

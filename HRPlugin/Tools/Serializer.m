//
//  Project: [HRPlugin]
//  Copyright (c) 2013年 daizhj. All rights reserved.
//  This is NOT a freeware, use is subject to license terms
//
//  Date:    13-5-31
//  Author:  代 震军

#import "Serializer.h"


@implementation Serializer


- (void)dealloc{
    unsigned int outCount, i;
    //自动释放属性对象
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[[NSString alloc] initWithUTF8String:property_getName(property)] autorelease];
        //[[self valueForKey:key] retain];
        [[self valueForKey:key] release];
        //NSLog(@"%@ retain-count:%d", key, [[self valueForKey:key] retainCount]);
    }
    [super dealloc];
}

- (id) initWithCoder: (NSCoder *)coder{
    //反射属性
    if (self = [super init]) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString * key = [[[NSString alloc] initWithUTF8String:property_getName(property)] autorelease];
            [self setValue:[coder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

+ (id) get:(NSString*)_key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:_key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
}

- (void) encodeWithCoder: (NSCoder *)coder{
    //反射属性
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[[NSString alloc] initWithUTF8String:property_getName(property)] autorelease];
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }
}

-(void) set:(NSString*)_key  {
    [Serializer set:_key obj:self];
}

+(void) set:(NSString*)_key obj:(id) _obj  {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //转成nsdata来保存
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:_obj];
    [ud setObject:udObject forKey:_key];
    [ud synchronize];
}

-(void) remove:(NSString*)_key  {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //转成nsdata来保存
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [ud removeObjectForKey:_key];
    [ud synchronize];
}
@end;

@implementation CommonConfig
@end




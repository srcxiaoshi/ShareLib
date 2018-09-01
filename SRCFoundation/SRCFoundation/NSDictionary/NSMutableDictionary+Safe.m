//
//  NSMutableDictionary+Safe.m
//  SRCFoundation
/***
 1、setObject是dictionary的方法，其中key不能是nil的其它实现<NSCopying>的对象 value 也不能是nil
 2、removeObjectForKey key 不能nil
 */
//  Created by 史瑞昌 on 2018/8/31.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"
#import "ErrorHome.h"

@implementation NSMutableDictionary (Safe)

-(void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if(aKey&&anObject)
    {
        [self setObject:anObject forKey:aKey];
    }
    else
    {
        ERROR();
    }
    
}


-(void)safe_removeObjectForKey:(id<NSCopying>)aKey
{
    if(aKey)
    {
        [self removeObjectForKey:aKey];
    }
    else
    {
        ERROR();
    }
}



@end

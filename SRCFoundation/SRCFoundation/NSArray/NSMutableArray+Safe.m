//
//  NSMutableArray+Safe.m
//  NSFoundation
//  数组越界crash
//  Created by 史瑞昌 on 2018/8/29.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import "ErrorHome.h"


@implementation NSMutableArray (Safe)

-(void)safe_addObject:(id)anObject
{
    if(anObject)
    {
        [self addObject:anObject];
    }
    else
    {
        ERROR();
    }
}

-(void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if(anObject&&index<=[self count])
    {
        [self insertObject:anObject atIndex:index];
    }
    else
    {
        ERROR();
    }
}


-(void)safe_removeObjectAtIndex:(NSUInteger)index
{
    if(index<[self count])
    {
        [self removeObjectAtIndex:index];
    }
    else
    {
        ERROR();
    }
}

-(void)safe_removeObject:(id)anObject
{
    if(anObject)
    {
        [self removeObject:anObject];
    }
    else
    {
        ERROR();
    }
}

-(id)safe_objectAtIndex:(NSUInteger)index
{
    if(index<[self count])
    {
        [self objectAtIndex:index];
    }
    else
    {
        ERROR();
    }
    return nil;
}



@end

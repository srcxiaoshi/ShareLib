//
//  NSArray+Safe.m
//  NSFoundation
//  数组越界crash
//  Created by 史瑞昌 on 2018/8/29.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSArray+Safe.h"
#import "ErrorHome.h"

@implementation NSArray (Safe)
-(id)safe_objectAtIndex:(NSUInteger)index
{
    if(index<[self count])
    {
        return [self objectAtIndex: index];
    }
    else
    {
        ERROR();
    }
    return nil;
}
@end

//
//  NSObject+Safe.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/6.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSObject+Safe.h"
#import "ErrorHome.h"
#import "NSString+Safe.h"


@implementation NSObject (Safe)

-(void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if(![self isKindOfClass:[NSObject class]])
    {
        ERROR();
        return;
    }
    if(!observer||[NSString safe_isEmpty:keyPath])
    {
        ERROR();
        return;
    }
    @try
    {
        [self removeObserver:observer forKeyPath:keyPath];
    }
    @catch (NSException *exp)
    {
        NSLog(@"%@\n",[exp description]);
        ERROR();
    }
    
    return;
}


@end

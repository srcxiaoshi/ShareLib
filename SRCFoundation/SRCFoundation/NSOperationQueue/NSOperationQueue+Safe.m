//
//  NSOperationQueue+Safe.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/6.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSOperationQueue+Safe.h"
#import "ErrorHome.h"


@implementation NSOperationQueue (Safe)

-(void)safe_addOperation:(NSOperation *)op
{
    if(!op)
    {
        ERROR();
        return;
    }
    if(![self operations]||[[self operations] count]==0)
    {
        ERROR();
        return;
    }
    if([[self operations] containsObject:op])
    {
        ERROR();
        return;
    }
    [self addOperation:op];
    
    return;
}

@end

//
//  NSTimer+Safe.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/5.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSTimer+Safe.h"
#import "ErrorHome.h"


@implementation NSTimer (Safe)

+(NSTimer *)safe_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    NSTimer *timer=nil;
    if(aTarget&&aSelector&&[aTarget respondsToSelector:aSelector])
    {
        timer=[NSTimer scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
        if(!timer)
        {
            ERROR();
        }
    }
    else
    {
        ERROR();
    }
    return timer;
}


@end

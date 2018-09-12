//
//  BaseModel.m
//  NSFoundation
//
//  Created by 史瑞昌 on 2018/9/10.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "BaseModel.h"
#import "ErrorHome.h"
#import "NSString+Safe.h"
#import "JSONModel.h"

@implementation BaseModel

#pragma overload 重写这个方法，加入一些判断
-(instancetype)safe_initWithString:(NSString *)string error:(JSONModelError *__autoreleasing *)err
{
    if(self&&[self isKindOfClass:[JSONModel class]])
    {
        if([NSString safe_isEmpty:string])
        {
            ERROR();
            return nil;
        }
        __autoreleasing JSONModelError *self_err=nil;
        typeof(self) temp= [self initWithString:string error:&self_err];
        if(self_err)
        {
            err=&self_err;
            ERROR();
            return nil;
        }
        if(temp)
        {
            return temp;
        }
        else
        {
            ERROR();
            return nil;
        }
    }
    else
    {
        ERROR();
        return nil;
    }
}

@end

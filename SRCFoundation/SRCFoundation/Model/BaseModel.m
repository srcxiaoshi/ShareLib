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
#import <objc/runtime.h>

@implementation BaseModel

//所有属性可选 Optional
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(instancetype)init
{
    self=[super init];
    if(self)
    {
        //这里动态创建protocol 使用类名 创建
        NSString *name=NSStringFromClass([self class]);
        Protocol *protocol = [self objc_allocateProtocol:[name UTF8String]];
        [self objc_registerProtocol:protocol];
        [self class_addProtocol:[self class] protocol:NSProtocolFromString(name)];
        return self;
    }
    else
    {
        return nil;
    }
}


#pragma overload
-(instancetype)safe_initWithString:(NSString *)string
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

/**
 *  添加协议
 *
 *  @param class    类
 *  @param protocol 协议
 */
- (void)class_addProtocol:(Class)class protocol:(Protocol *)protocol {
    if(protocol)
    {
        const char *name=[self protocol_getName:protocol];
        NSString *proName=[NSString stringWithUTF8String:name];
        if([NSString safe_isEmpty:proName])
        {
            //添加
            BOOL isSuccess=class_addProtocol(class, protocol);
            if (!isSuccess)
            {
                //NSLog(@"%@ fail",class);
                ERROR();
            }
            else
            {
                //NSLog(@"%@ success",class);
            }
        }
        else
        {
            // 返回 什么都不用做
        }
    }
    
    
    
}


/**
 *  在运行时中注册新创建的协议
 *
 *  @param protocol 协议
 */
- (void)objc_registerProtocol:(Protocol *)protocol {
    if (protocol)
    {
        //NSLog(@"%@ objc_registerProtocol",protocol);
        objc_registerProtocol(protocol);
    }
}


/**
 *  查看类是否遵循指定协议
 *
 *  @param class    类
 *  @param protocol 协议
 */
- (BOOL)class_conformsToProtocol:(Class)class protocol:(Protocol *)protocol {
    if(class||protocol)
    {
        return NO;
    }
    if (class_conformsToProtocol(class, protocol))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *  创建新的协议实例
 *
 *  @param name 协议名称
 *
 *  @return 协议实例
 */
- (Protocol *)objc_allocateProtocol:(const char *)name {
    // 检查该协议是否已经注册
    Protocol *pro=[self objc_getProtocol:name];
    if (!pro)
    {
        Protocol *protocol = objc_allocateProtocol(name);
        //NSLog(@"%s,%@ objc_allocateProtocol",name,protocol);
        return protocol;
    }
    return nil;
}

/**
 *  获取指定名字的协议
 *
 *  @param name 协议名称
 */
- (Protocol *)objc_getProtocol:(const char *)name {
    Protocol *protocol = objc_getProtocol(name);
    if(protocol)
    {
        return protocol;
    }
    else
    {
        return nil;
    }
}

/**
 *  获取协议名字
 *
 *  @param protocol 协议
 */
- (const char *)protocol_getName:(Protocol *)protocol {
    if (protocol)
    {
        return protocol_getName(protocol);
    }
    else
    {
        return nil;
    }
}


@end

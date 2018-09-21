//
//  UIColor+Easy.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/18.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "UIColor+Easy.h"

@implementation UIColor (Easy)

/**
 *  获取红色通道的值
 *
 */
-(CGFloat)getRed
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

/**
 *  获取蓝色通道的值
 *
 */
-(CGFloat)getBlue
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

/**
 *  获取绿色通道的值
 *
 */
-(CGFloat)getGreen
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

/**
 *  获取透明通道的值
 *
 */
-(CGFloat)getAlpha
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return a;
}

@end

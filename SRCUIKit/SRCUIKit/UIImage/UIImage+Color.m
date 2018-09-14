//
//  UIImage+Color.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/14.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+(UIImage *)imageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    //自己创建位图上下文
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    //这里开始
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:red green:green blue:blue alpha:alpha] CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //这里结束
    UIGraphicsEndImageContext();
    return image;
}

@end

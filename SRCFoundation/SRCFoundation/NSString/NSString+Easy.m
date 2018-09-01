//
//  NSString+Easy.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/8/31.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSString+Easy.h"
#import "ErrorHome.h"
#import "NSMutableDictionary+Safe.h"

@implementation NSString (Easy)


//比较大小函数
-(BOOL)easy_stringCompare:(NSString *)str
{
    if (str)
    {
        if ([str length]==0)
        {
            return YES;
        }
        return (CFStringCompare((CFStringRef)self, (CFStringRef)str, kCFCompareNumerically) == kCFCompareGreaterThan);
    }
    else
    {
        ERROR();
    }
    
    return YES;
}

//这个方法没有调用后面的两个参数的默认方法
- (CGSize)easy_sizeWithFont:(UIFont *)font
{
    if(font)
    {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes safe_setObject:font forKey:NSFontAttributeName];
        return [self sizeWithAttributes:attributes];
    }
    else
    {
        ERROR();
    }
    return CGSizeZero;
}

//根据宽度和字体、换行规则 计算大小  这里也是构造了一个新的size用来调用多参数方法
- (CGSize)easy_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize constrainedSize = CGSizeMake(width, 1024);
    return [self easy_sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
}

//这个方法调用了后面多个参数的方法的默认方法
- (CGSize)easy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self easy_sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}


//这个方法是根据当前size和分行方式、字体计算新的宽高()
-(CGSize)easy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if(font)
    {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = lineBreakMode;
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes safe_setObject:[paragraph copy] forKey:NSParagraphStyleAttributeName];
        [attributes safe_setObject:font forKey:NSFontAttributeName];
        CGRect boundingRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        return boundingRect.size;
    }
    else
    {
        ERROR();
    }
    return CGSizeZero;
}

@end

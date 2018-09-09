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

#pragma 比较函数
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

#pragma 获取app 名字 版本 build版本
+(NSString *)easy_appName
{
    static NSDictionary *infoDictionary;
    if(!infoDictionary)
    {
        infoDictionary=[[NSBundle mainBundle] infoDictionary];
    }
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}

//Version
+(NSString *)easy_appVersion
{
    static NSDictionary *infoDictionary;
    if(!infoDictionary)
    {
        infoDictionary=[[NSBundle mainBundle] infoDictionary];
    }
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

//Build
+(NSString *)easy_appBuild
{
    static NSDictionary *infoDictionary;
    if(!infoDictionary)
    {
        infoDictionary=[[NSBundle mainBundle] infoDictionary];
    }
    return [infoDictionary objectForKey:@"CFBundleVersion"];
}



#pragma 根据字体获取size
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


#pragma 获取当前时间字符串
+(NSString *)easy_normalDate
{
    static NSDateFormatter *inFormatter=nil;
    if(!inFormatter)
    {
        inFormatter=[[NSDateFormatter alloc] init];
        [inFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    }
    return [inFormatter stringFromDate:[NSDate date]];
}




#pragma html 相关
-(NSString *)easy_replaceHtmlSymbol
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"&#x22" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&#x5C" withString:@"\\"];
    str = [str stringByReplacingOccurrencesOfString:@"&#x27" withString:@"'"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&rt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    //将来发现了新的符号，再处理 添加在这里
    
    return str;
}

@end

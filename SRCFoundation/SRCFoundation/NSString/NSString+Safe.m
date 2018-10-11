//
//  NSString+Safe.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/8/31.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSString+Safe.h"
#import "ErrorHome.h"


@implementation NSString (Safe)

//去掉前后空格和回车符
-(NSString *)safe_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//判空 传入的是nil NULL null 非nsstring "(null)" " \n" 如有新的形式，再补充
+(BOOL)safe_isEmpty:(NSString *)str
{
    return ![self safe_isNotEmpty:str];
    
}

//判空 传入的是nil NULL null 非nsstring "(null)" " \n" 如有新的形式，再补充
+(BOOL)safe_isNotEmpty:(NSString *)str
{
    if(
       str
       &&![str isEqual:[NSNull null]]
       &&[str isKindOfClass:[NSString class]]
       &&![str isEqualToString:@"(null)"]
       &&[[str safe_trim] length]>0
       )
    {
        return YES;
    }
    return NO;

}

-(NSString *)safe_substringToIndex:(NSUInteger)to
{
    if(to<=[self length])
    {
        return [self substringToIndex:to];
    }
    else
    {
        ERROR();
    }
    return nil;
}


-(NSString *)safe_substringFromIndex:(NSUInteger)from
{
    if(from<=[self length])
    {
        return [self substringFromIndex:from];
    }
    else
    {
        ERROR();
    }
    return nil;
}


-(NSString *)safe_substringWithRange:(NSRange)range
{
    if(range.location<=[self length]&&range.length+range.location<=[self length])
    {
        return [self substringWithRange:range];
    }
    else
    {
        ERROR();
    }
    return nil;
}


-(NSString *)safe_stringByAppendingString:(NSString *)aString
{
    if(aString)
    {
        return [self stringByAppendingString:aString];
    }
    else
    {
        ERROR();
    }
    return nil;
}

-(NSRange)safe_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask
{
    if(searchString)
    {
        return [self rangeOfString:searchString options:mask];
    }
    else
    {
        ERROR();
    }
    return NSMakeRange(NSNotFound, 0);
}








@end

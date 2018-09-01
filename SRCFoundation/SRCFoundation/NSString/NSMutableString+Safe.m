//
//  NSMutableString+Safe.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/8/31.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSMutableString+Safe.h"
#import "ErrorHome.h"


@implementation NSMutableString (Safe)


-(void)safe_appendString:(NSString *)aString
{
    if(aString)
    {
        [self appendString:aString];
    }
    else
    {
        ERROR();
    }
}

-(void)safe_insertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    if(aString&&loc<=[self length])
    {
        [self insertString:aString atIndex:loc];
    }
    else
    {
        ERROR();
    }
}

-(void)safe_deleteCharactersInRange:(NSRange)range
{
    if(range.location<=[self length]&&range.length+range.location<=[self length])
    {
        [self deleteCharactersInRange:range];
    }
    else
    {
        ERROR();
    }
}





@end

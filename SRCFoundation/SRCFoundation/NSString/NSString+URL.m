//
//  NSString+URL.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/1.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSString+URL.h"
#import "NSString+Safe.h"
#import "NSArray+Safe.h"
#import "NSMutableString+Safe.h"
#import "NSMutableDictionary+Safe.h"

@implementation NSString (URL)

-(NSString *)URL_hostFromURLString
{
    if([self length]>0)
    {
        //使用utf-8编码
        NSString *strURl = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url=[NSURL URLWithString:strURl];
        
        if(url)
        {
            NSString *hostName = [url host];
            hostName=[hostName stringByRemovingPercentEncoding];
            return hostName;
        }
        else
            return nil;
    }
    return nil;
}

//这个方法是把url中的参数，按照dictionary取到dict中
-(NSDictionary *)URL_paramsFromURLString
{
    //没有办法处理的情况:参数是[]数组的
    if([NSString safe_isEmpty:self]||[self isEqualToString:@""])
        return nil;
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSArray *arr=[self componentsSeparatedByString:@"?"];//第一个参数之前是？
    if(!arr||[arr count]<=1)
        return nil;
    NSString *para=[arr safe_objectAtIndex:1];
    if([NSString safe_isEmpty:para]||[para isEqualToString:@""])
        return nil;
    arr=[para componentsSeparatedByString:@"&"];
    if(!arr||[arr count]==0)
        return nil;
    for(int i=0;i<[arr count];i++)
    {
        //处理“=”
        NSString *tmp=[arr safe_objectAtIndex:i];
        if ([NSString safe_isEmpty:tmp]||[tmp isEqualToString:@""]) {
            continue;
        }
        NSArray *temp_arr=[tmp componentsSeparatedByString:@"="];
        if(!temp_arr||[temp_arr count]<2)
        {
            continue;
        }
        NSString *key=[temp_arr safe_objectAtIndex:0];
        NSMutableString *value=[temp_arr safe_objectAtIndex:1];
        if([temp_arr count]>2)
        {
            //这里是防止value中存在=
            for(int j=2;j<[temp_arr count];j++)
            {
                NSString *t_value=[temp_arr safe_objectAtIndex:j];
                if ([NSString safe_isEmpty:t_value]) {
                    continue;
                }
                value=[[value safe_stringByAppendingString:t_value] copy];
            }
        }
        [dic safe_setObject:value forKey:key];
    }
    return dic;
}



-(NSString *)URL_fileNameFromURLString
{
    if([self length]>0)
    {
        NSString *str=[self lastPathComponent];
        if([NSString safe_isEmpty:str])
        {
            return nil;
        }
        else
        {
            return str;
        }
    }
    return nil;
}










@end

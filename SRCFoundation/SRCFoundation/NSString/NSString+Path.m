//
//  NSString+Path.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/1.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSString+Path.h"
#import "NSString+Easy.h"

@implementation NSString (Path)

+(NSString *)HomePath
{
    return NSHomeDirectory();
}

+(NSString *)TempPath
{
    NSString *path = [NSTemporaryDirectory() stringByStandardizingPath];
    return path;
}

//使用静态变量，懒加载
+(NSString *)DocPath
{
    static NSString *documentsDirectory;
    if (documentsDirectory == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
    }
    return documentsDirectory;
}

//使用静态变量，懒加载
+(NSString *)LibPath{
    static NSString *libarariesDirectory;
    if(libarariesDirectory == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        libarariesDirectory = [paths objectAtIndex:0];
    }
    return libarariesDirectory;
}

//获取.app的路径 这里主要是Stock
+(NSString *)AppPath
{
    return [NSString stringWithFormat:@"%@/%@.app", NSHomeDirectory(),[NSString easy_appName]];
}

//移除对应的路径
+(BOOL)RemovePath:(NSString *)path
{
    if (path == nil)
        return NO;
    NSFileManager *FM = [NSFileManager defaultManager];
    return [FM removeItemAtPath:path error:NULL];;
}



@end

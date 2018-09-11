//
//  AppInfo.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/11.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

// app名称
+(NSString *)app_name
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}

// app版本
+(NSString *)app_version
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

// app build版本
+(NSString *)app_build
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_build;
}

@end

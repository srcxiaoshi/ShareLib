//
//  SRCDeviceInfo.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/15.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SRCDeviceInfo.h"
#import <UIKit/UIKit.h>

iPhoneDeviceType global_deviceType;


@implementation SRCDeviceInfo

+(void)GloBalDeviceType
{
    iPhoneDeviceType type=iPhoneDeviceTypeIPhone4;
    CGRect bounds=[[UIScreen mainScreen] bounds];
    CGFloat height=bounds.size.height;
    if (height<568) {
        type=iPhoneDeviceTypeIPhone4S;
    }
    else if(height<667)
    {
        type=iPhoneDeviceTypeIPhone5S;
    }
    else if(height<736)
    {
        type=iPhoneDeviceTypeIPhone6;
    }
    else if(height<812)
    {
        type=iPhoneDeviceTypeIPhone6P;
    }
    else if(height==812)
    {
        type=iPhoneDeviceTypeIPhoneX;
    }
    global_deviceType=type;
}

@end

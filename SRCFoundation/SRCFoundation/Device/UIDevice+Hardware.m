//
//  UIDevice+Hardware.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/10.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//
#include <sys/sysctl.h>
#include <sys/socket.h> // Per msqr
#include <net/if.h>
#include <net/if_dl.h>

#import "UIDevice+Hardware.h"

@implementation UIDevice (Hardware)

#pragma mark sysctl utils
+(NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

/**
 * cpu频率
 *
 */
+(NSUInteger)cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

/**
 * bus频率
 *
 */
+(NSUInteger)busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

/**
 * cpu核数
 *
 */
+(NSUInteger)cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

/**
 * 内存 总数
 *
 */
+(NSUInteger)totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

/**
 * 内存 可使用
 *
 */
+(NSUInteger)userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

/**
 * 硬盘空间 总数
 *
 */
+(NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

/**
 * 硬盘空间 剩余
 *
 */
+(NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

/**
 * mac 地址
 *
 */
+(NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    return outstring;
}

/**
 * 是不是Retina屏幕
 *
 */
+(BOOL)hasRetinaDisplay
{
    return ([[UIScreen mainScreen] scale]>1.0f);
}

/**
 * 最大SocketBuffer大小
 *
 */
+(NSUInteger)maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

@end

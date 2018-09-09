//
//  NSFileManager+Safe.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/6.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "NSFileManager+Safe.h"
#import "ErrorHome.h"
#import "NSString+Safe.h"



@implementation NSFileManager (Safe)

-(const char *)safe_fileSystemRepresentationWithPath:(NSString *)path
{
    if([NSString safe_isEmpty:path]||[path isEqualToString:@""])
    {
        ERROR();
        return NULL;
    }
    return [self fileSystemRepresentationWithPath:path];
}

@end

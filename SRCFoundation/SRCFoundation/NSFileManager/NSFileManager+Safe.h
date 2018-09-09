//
//  NSFileManager+Safe.h
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/6.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Safe)

-(const char *)safe_fileSystemRepresentationWithPath:(NSString *)path;

@end

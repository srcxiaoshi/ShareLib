//
//  SRCNetworkingForImage.h
//  SRCUIKit
//
//  该类用来封装af，用来上传和下载文件 
//  Created by 史瑞昌 on 2018/9/27.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AFHTTPSessionManager;
@interface SRCNetworkingForImage : NSObject

/**
 * 根据url下载image 返回task
 *
 **/
+(NSURLSessionTask *)downloadImageWithURL:(NSURL *)url prograss:(void(^) (float prograss))prograssBlock completion:(void(^)(NSURL *filepath))completionBlock;


/**
 *  取消对应的任务
 *
 */
+(void)cancelTask:(NSURLSessionTask *)task;

@end

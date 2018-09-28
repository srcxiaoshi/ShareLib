//
//  SRCImageView.m
//  SRCUIKit
//  一个imageView 依赖一个task
//  Created by 史瑞昌 on 2018/9/27.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SRCImageView.h"
#import "Error.h"
#import <SRCFoundation/SRCFoundation.h>


@interface SRCImageView()

@end


@implementation SRCImageView

static NSCache *cache;

+(NSCache *)ShareImagesCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache=[[NSCache alloc] init];
    });
    return cache;
}


-(UIImage *)imageFromCacheWith:(NSURL *) url
{
    if(!url)
    {
        ERROR();
        return nil;
    }
    return [[SRCImageView ShareImagesCache] objectForKey:[url absoluteString]];
}

-(void)cacheImage:(UIImage *)image forURL:(NSURL *)url
{
    if(!image||!url)
    {
        ERROR();
        return;
    }
    //以image的宽*高为代价，缓存image
    [[SRCImageView ShareImagesCache] setObject:image forKey:[url absoluteString] cost:image.size.width*image.size.height];
}


#pragma mark -public
/**
 * 加载Image
 *  1、webImage的url
 **/
- (void)src_setImageWithURL:(NSURL *)url;
{
    [self src_setImageWithURL:url placeholderImage:nil progress:nil completed:nil];
}

/**
 * 加载Image
 *  1、webImage的url 2、占位image
 **/
- (void)src_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self src_setImageWithURL:url placeholderImage:placeholder progress:nil completed:nil];
}

/**
 * 加载Image
 *  1、webImage的url 2、占位image 3、加载进度
 **/
- (void)src_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder  progress:(void(^)(CGFloat progress))progressBlock
{
    [self src_setImageWithURL:url placeholderImage:placeholder progress:progressBlock completed:nil];
}


/**
 * 加载Image
 *  1、webImage的url 2、占位image 3、加载进度 4、下载完成后
 **/
- (void)src_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder  progress:(void(^)(CGFloat progress))progressBlock completed:(void(^)(void))completedBlock
{
    if(!url)
    {
        ERROR();
        return;
    }
    //因为placeholder 应该是经常用，且小的，所以placeholder应该是imageNamed来获取的
    self.image=placeholder;

    __weak typeof(self) weakself=self;
    //流程如下
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(weakself) strongself=weakself;
        //1、先查缓存cache
        UIImage *temp=[strongself imageFromCacheWith:url];
        if(temp)
        {
            //去对temp异步解压 然后绘制

            dispatch_async(dispatch_get_main_queue(), ^{

            });
            return;
        }

        //2、查本地 Library/Caches/ 下的具体文件
        //获取文件名字
        NSString *str=[url absoluteString];
        if(![NSString safe_isEmpty:str])
        {
            str=[str URL_fileNameFromURLString];
            if(![NSString safe_isEmpty:str])
            {
                NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:str];
                UIImage *image=[UIImage imageWithContentsOfFile:fullpath];
                //异步加载 解压 绘制

                dispatch_async(dispatch_get_main_queue(), ^{

                });
                return;
            }
        }

        //3、从网络下载
        [SRCNetworkWithAF downloadFileWithURL:url prograss:nil completion:^(NSURL *filepath) {
            if(filepath)
            {
                //异步 缓存 加载 解压 绘制
                UIImage *image=[UIImage imageWithContentsOfFile:filepath];

                dispatch_async(dispatch_get_main_queue(), ^{

                });
            }
        }];

    }) ;

}

/**
 * 加载Image
 *  1、image UIImage 实例
 **/
-(void)decoderImage:(UIImage *)image
{
    //return nil;
}

@end

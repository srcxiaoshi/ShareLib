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

#import "UIImage+WebP.h"
#import "UIImage+Type.h"


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


-(NSData *)imageFromCacheWith:(NSURL *) url
{
    if(!url)
    {
        ERROR();
        return nil;
    }
    return [[SRCImageView ShareImagesCache] objectForKey:[url absoluteString]];
}

-(void)cacheImage:(NSData *)imageData forURL:(NSURL *)url
{
    if(!imageData||!url)
    {
        ERROR();
        return;
    }
    //缓存image 暂时没有cost，后面这里要改
    [[SRCImageView ShareImagesCache] setObject:imageData forKey:[url absoluteString]];
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
    if(placeholder)
    {
        self.image=placeholder;
    }

    __weak typeof(self) weakself=self;
    //流程如下
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        __strong typeof(weakself) strongself=weakself;
        //1、先查缓存cache
        NSData *data=[strongself imageFromCacheWith:url];
        if([strongself asyncDrawImage:data])
            return;

        //2、查磁盘
        //获取文件名字
        NSString *str=[url absoluteString];
        if(![NSString safe_isEmpty:str])
        {
            str=[str URL_fileNameFromURLString];
            
            if(![NSString safe_isEmpty:str])
            {
                NSString *fullpath = NSTemporaryDirectory();
                fullpath=[fullpath safe_stringByAppendingString:str];

                //加载
                NSData *data=[[NSData alloc] initWithContentsOfFile:fullpath];
                if([strongself asyncDrawImage:data])
                {
                    [strongself asyncCache:data url:url];
                    return;
                }
            }
        }

        //3、从网络下载
        [SRCNetworkWithAF downloadFileWithURL:url prograss:nil completion:^(NSURL *filepath) {
            if(filepath)
            {
                [strongself asyncDrawImageWithFilePath:filepath sourceURL:url];
            }
        }];

    }) ;

}

-(void)asyncCache:(NSData *)data url:(NSURL *)url
{
    __weak typeof(self) weakself=self;
    //写缓存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(weakself) strongself=weakself;
        [strongself cacheImage:data forURL:url];
    });
}

//从本地文件filepath 来读取
-(BOOL)asyncDrawImageWithFilePath:(NSURL *)filepath sourceURL:(NSURL *)url
{
    if(filepath)
    {
        //加载 此方法不会缓存.在autorelease 的时候 可能会释放
        NSData *data=[NSData dataWithContentsOfFile:[filepath path]];

        if(data)
        {
            if([self asyncDrawImage:data])
            {
                __weak typeof(self) weakself=self;
                //写缓存
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    __strong typeof(weakself) strongself=weakself;
                    [strongself cacheImage:data forURL:url];
                });
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

//从data -> image
-(BOOL)asyncDrawImage:(NSData *)data
{
    if(data)
    {
        UIImage *image=nil;
        //判断image格式
        SRCImageType type=[UIImage SRCImageTypeFromImageData:data];
        //这里是webp格式
        if(type==SRCImageTypeWEBP)
        {
            //解压缩
            image=[UIImage SRCImageFromImageData:data];

            //离线绘制
            image=[self decodeImage:image];
        }
        else if(type==SRCImageTypeJPEG||type==SRCImageTypePNG)
        {
            image=[UIImage imageWithData:data];
            //离线绘制
            image=[self decodeImage:image];
        }
        if(image)
        {
            __weak typeof(self) weakself=self;
            dispatch_main_async_safe(^{
                __strong typeof(weakself) strongself=weakself;
                //赋值
                strongself.image=image;
            });
            return YES;
        }
        else
        {
            return NO;
        }

    }
    else
    {
        return NO;
    }
}

//使用CGBitmapContextCreate  传入一副图片对该图片进行解码，解码结果是另一幅图片
-(UIImage *)decodeImage:(UIImage *)image
{
    if(!image)
    {
        return nil;
    }

    @autoreleasepool{
        // 不解码 animation gif
        if (image.images != nil) {
            return image;
        }

        CGImageRef imageRef = image.CGImage;
        //是否有alpha通道
        CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
        BOOL anyAlpha = (alpha == kCGImageAlphaFirst ||
                         alpha == kCGImageAlphaLast ||
                         alpha == kCGImageAlphaPremultipliedFirst ||
                         alpha == kCGImageAlphaPremultipliedLast);
        CGBitmapInfo info = kCGBitmapByteOrder32Host | (anyAlpha ? kCGImageAlphaPremultipliedFirst: kCGImageAlphaNoneSkipFirst);
        //获取颜色通道
        CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef));
        CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
        //https://www.jianshu.com/p/9b30109b302e 通道支持表，参考网页
        BOOL unsupportedColorSpace = (imageColorSpaceModel == kCGColorSpaceModelUnknown ||
                                      imageColorSpaceModel == kCGColorSpaceModelMonochrome ||
                                      imageColorSpaceModel == kCGColorSpaceModelCMYK ||
                                      imageColorSpaceModel == kCGColorSpaceModelIndexed);
        if (unsupportedColorSpace) {
            colorspaceRef = CGColorSpaceCreateDeviceRGB();
        }

        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        NSUInteger bytesPerPixel = 4;
        NSUInteger bytesPerRow = bytesPerPixel * width;
        NSUInteger bitsPerComponent = 8;


        // kCGImageAlphaNone is not supported in CGBitmapContextCreate.
        // Since the original image here has no alpha info, use kCGImageAlphaNoneSkipLast
        // to create bitmap graphics contexts without alpha info.
        // kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast)
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorspaceRef,
                                                     info);

        // Draw the image into the context and retrieve the new bitmap image without alpha
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGImageRef imageRefC= CGBitmapContextCreateImage(context);
        UIImage *imageC = [UIImage imageWithCGImage:imageRefC
                                                         scale:image.scale
                                                   orientation:image.imageOrientation];

        if (unsupportedColorSpace) {
            CGColorSpaceRelease(colorspaceRef);
        }

        CGContextRelease(context);
        CGImageRelease(imageRefC);

        return imageC;
    }


}

@end

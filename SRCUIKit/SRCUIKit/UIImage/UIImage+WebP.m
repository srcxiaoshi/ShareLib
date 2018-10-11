//
//  UIImage+WebP.m
//  SRCUIKit
//
//  source from sdwebImage
//
//  Created by 史瑞昌 on 2018/9/28.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "UIImage+WebP.h"
#import "decode.h"

@implementation UIImage (WebP)

// Callback for CGDataProviderRelease
static void FreeImageData(void *info, const void *data, size_t size)
{
    free((void *)data);
}

/**
 * 从NSData -> Image
 */
+ (UIImage *)SRCImageFromImageData:(NSData *)data
{
    if(!data)
    {
        return nil;
    }
    @autoreleasepool
    {
        WebPDecoderConfig config;
        if (!WebPInitDecoderConfig(&config)) {
            return nil;
        }

        if (WebPGetFeatures(data.bytes, data.length, &config.input) != VP8_STATUS_OK) {
            return nil;
        }

        config.output.colorspace = config.input.has_alpha ? MODE_rgbA : MODE_RGB;
        config.options.use_threads = 1;

        // Decode the WebP image data into a RGBA value array.
        if (WebPDecode(data.bytes, data.length, &config) != VP8_STATUS_OK) {
            return nil;
        }

        int width = config.input.width;
        int height = config.input.height;
        if (config.options.use_scaling) {
            width = config.options.scaled_width;
            height = config.options.scaled_height;
        }

        // Construct a UIImage from the decoded RGBA value array.
        CGDataProviderRef provider =
        CGDataProviderCreateWithData(NULL, config.output.u.RGBA.rgba, config.output.u.RGBA.size, FreeImageData);
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmapInfo = config.input.has_alpha ? kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast : 0;
        size_t components = config.input.has_alpha ? 4 : 3;
        CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
        CGImageRef imageRef = CGImageCreate(width, height, 8, components * 8, components * width, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);

        CGColorSpaceRelease(colorSpaceRef);
        CGDataProviderRelease(provider);

        UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
        CGImageRelease(imageRef);
        return image;

    };


}

@end

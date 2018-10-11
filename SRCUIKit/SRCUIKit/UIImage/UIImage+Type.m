//
//  UIImage+Type.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/28.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "UIImage+Type.h"

@implementation UIImage (Type)


/**
 * 学习sd 来解析ImageData的Type
 *
 */
+(SRCImageType)SRCImageTypeFromImageData:(NSData *)data {
    if(!data)
    {
        return SRCImageTypeUnkown;
    }
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return SRCImageTypeJPEG;
        case 0x89:
            return SRCImageTypePNG;
        case 0x47:
            return SRCImageTypeGIF;
        case 0x49:
        case 0x4D:
            return SRCImageTypeTIFF;
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return SRCImageTypeUnkown;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return SRCImageTypeWEBP;
            }

            return SRCImageTypeUnkown;
    }
    return SRCImageTypeUnkown;
}

@end

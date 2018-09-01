//
//  NSString+Easy.h
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/8/31.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (Easy)

//比较大小
- (BOOL)easy_stringCompare:(NSString*)str;


- (NSString *)easy_filterMark:(NSString *)str;

- (CGSize)easy_sizeWithFont:(UIFont *)font;
- (CGSize)easy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)easy_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)easy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (void)easy_drawInRect:(CGRect)rect withFont:(UIFont *)font;
- (void)easy_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)easy_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;


@end

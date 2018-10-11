//
//  SRCUILabel+Easy.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/29.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SRCUILabel+Easy.h"
#import "SRCUILabel.h"



@implementation SRCUILabel (Easy)

+(SRCUILabel *)easy_UILabel:(CGRect)frame fontSize:(CGFloat)fontSize textColor:(UIColor *)color
{
    SRCUILabel *label=[[SRCUILabel alloc] initWithFrame:frame];
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:fontSize];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.opaque=NO;
    label.textAlignment=NSTextAlignmentLeft;
    if(color)
    {
        label.textColor=color;
    }
    return label;
}


+(SRCUILabel *)easy_UILabel:(CGFloat)fontSize textColor:(UIColor *)color
{
    return [self easy_UILabel:CGRectZero fontSize:fontSize textColor:color];
}


@end

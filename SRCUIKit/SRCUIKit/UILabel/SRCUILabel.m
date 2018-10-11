//
//  SRCUILabel.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/10/9.
//  Copyright © 2018 史瑞昌. All rights reserved.
//

#import "SRCUILabel.h"
#import <SRCFoundation/SRCFoundation.h>


@implementation SRCUILabel


//动态高
-(void)setText:(NSString *)text
{
    [super setText:text];
    //根据text更新frame
    if([NSString safe_isEmpty:text])
    {
        ERROR();
        return;
    }
    else
    {
        CGSize size=[text easy_sizeWithFont:self.font forWidth:self.frame.size.width lineBreakMode:NSLineBreakByWordWrapping];
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  TextFieldWithSearch.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/15.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SRCTextFieldWithSearch.h"
#import "Error.h"
#import "SRCDeviceInfo.h"





@implementation SRCTextFieldWithSearch

//这里有风险，返回的是一个(0,0,0,0)
-(instancetype)init
{
    return [self initWithFrame:CGRectMake(NAV_BAR_SEARCH_TEXT_EDGE_LEFT, NavHeight-NAV_BAR_SEARCH_TEXT_EDGE_BOTTOM, NAV_BAR_SEARCH_TEXT_WIDTH, NAV_BAR_SEARCH_TEXT_HEIGHT)];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame: frame];
    if(self)
    {
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.backgroundColor = [UIColor whiteColor];
        
        //搜索图片
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        leftView.image = [UIImage imageNamed:@"searchicon_search_20x20_"];
        self.leftView = leftView;
        CGRect rect=self.leftView.frame;
        rect.origin.x+=8;
        self.leftView.frame=rect;
        self.delegate=self;
        self.text = @"搜你想搜的";
        self.textColor = [UIColor grayColor];
        self.font = [UIFont systemFontOfSize:12];
        self.leftViewMode = UITextFieldViewModeAlways;
        
        return self;
    }
    else
    {
        ERROR();
        return nil;
    }
}



#pragma delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.searchEditDelegate&&[[self searchEditDelegate] respondsToSelector:@selector(searchTextFieldShouldBeginEditing:)])
    {
        return [[self searchEditDelegate] searchTextFieldShouldBeginEditing:textField];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([self searchEditDelegate]&&[[self searchEditDelegate] respondsToSelector:@selector(searchTextFieldDidBeginEditing:)])
    {
        [[self searchEditDelegate] searchTextFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if([self searchEditDelegate]&&[[self searchEditDelegate] respondsToSelector:@selector(searchTextFieldShouldEndEditing:)])
    {
        return [[self searchEditDelegate] searchTextFieldShouldEndEditing:textField];
    }
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if([self searchEditDelegate]&&[[self searchEditDelegate] respondsToSelector:@selector(searchTextFieldShouldClear:)])
    {
        return [[self searchEditDelegate] searchTextFieldShouldClear:textField];
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self searchEditDelegate]&&[[self searchEditDelegate] respondsToSelector:@selector(searchTextFieldShouldReturn:)])
    {
        return [[self searchEditDelegate] searchTextFieldShouldReturn:textField];
    }
    return NO;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

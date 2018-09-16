//
//  NavgationBarWithSearchAndCamera.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/15.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//




#import "SRCNavgationBarWithSearchAndCamera.h"
#import "Error.h"
#import "SRCDeviceInfo.h"
#import "SRCTextFieldWithSearch.h"


#define CAMERAVIEW_WIDTH    30
#define CAMERAVIEW_HEIGHT   30
#define SRC_NAV_BAR_BACKGROUND_COLOR    [UIColor colorWithRed:1.0 green:0.1 blue:0.1 alpha:1]

@interface SRCNavgationBarWithSearchAndCamera()<SRCTextFieldDelegateWithSearch>

@property(nonatomic,strong)SRCTextFieldWithSearch *textField;
@property(nonatomic,strong)UIImageView *cameraView;

@end

@implementation SRCNavgationBarWithSearchAndCamera

-(instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, NavHeight)];
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor=SRC_NAV_BAR_BACKGROUND_COLOR;
        //相机按钮 30*30  右15 下 9
        self.cameraView = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH-CAMERAVIEW_WIDTH-15, NavHeight-9-CAMERAVIEW_HEIGHT, CAMERAVIEW_WIDTH, CAMERAVIEW_HEIGHT)];
        self.cameraView.image = [UIImage imageNamed:@"home_camera"];
        self.cameraView.userInteractionEnabled=YES;
        //初始化一个手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePress)];
        //为图片添加手势
        [self.cameraView addGestureRecognizer:singleTap];
        [self addSubview:self.cameraView];
        
        //文本输入框
        self.textField=[[SRCTextFieldWithSearch alloc] initWithFrame:CGRectMake(NAV_BAR_SEARCH_TEXT_EDGE_LEFT, NavHeight-NAV_BAR_SEARCH_TEXT_EDGE_BOTTOM-NAV_BAR_SEARCH_TEXT_HEIGHT, VIEW_WIDTH-NAV_BAR_SEARCH_TEXT_EDGE_LEFT*2-CAMERAVIEW_WIDTH-15, NAV_BAR_SEARCH_TEXT_HEIGHT)];
        self.textField.searchEditDelegate=self;
        [self addSubview:self.textField];
    
        return self;
    }
    else
    {
        ERROR();
        return nil;
    }
}

//imageViewPress事件
-(void)imagePress
{
    if(self.imagePressBlock)
    {
        self.imagePressBlock();
    }
}


#pragma delegate
- (BOOL)searchTextFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.searchTextBlock)
    {
        self.searchTextBlock();
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

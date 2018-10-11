//
//  SRCBaseTableViewCell.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/29.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SRCBaseTableViewCell.h"
#import "SRCUILabel+Easy.h"
#import "SRCDeviceInfo.h"


@interface SRCBaseTableViewCell()

@property(nonatomic,strong)UIView *line;

@end

@implementation SRCBaseTableViewCell


//没有指定高度
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        //去除点击 后的样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        //高度提前计算过了，所以这里直接使用
        self.title=[SRCUILabel easy_UILabel:BASE_CELL_TITLE_FONT_SIZE textColor:[UIColor blackColor]];
        self.title.text=@"title";
        self.title.frame=CGRectMake(BASE_CELL_EDGE, BASE_CELL_EDGE, (VIEW_WIDTH-2*BASE_CELL_EDGE), 0);
        [self.contentView addSubview:self.title];

        self.info=[SRCUILabel easy_UILabel:BASE_CELL_SOURCE_FONT_SIZE textColor:[UIColor grayColor]];
        self.info.numberOfLines=1;
        self.info.text=@"info";
        [self.contentView addSubview:self.info];


        self.deleteButton=[[UIImageView alloc] init];
        self.deleteButton.image=[UIImage imageNamed:@"add_textpage_20x14_"];

        self.deleteButton.userInteractionEnabled=YES;
        UITapGestureRecognizer *gest=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteBtnTouch)];
        [self.deleteButton addGestureRecognizer:gest];
        [self.contentView addSubview:self.deleteButton];


        self.line=[[UIView alloc]init];
        [self.line setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:self.line];
    }
    return self;
}

//重写layoutSubViews方法，设置位置及尺寸
-(void)layoutSubviews
{
    [super layoutSubviews];


    self.info.frame=CGRectMake(BASE_CELL_EDGE, self.bounds.size.height-BASE_CELL_EDGE-BASE_CELL_SOURCE_FONT_SIZE, (VIEW_WIDTH-2*BASE_CELL_EDGE-BASE_CELL_DELETE_BUTTON_WIDTH), BASE_CELL_DELETE_BUTTON_HEIGH);

    self.deleteButton.frame=CGRectMake((VIEW_WIDTH-BASE_CELL_EDGE-BASE_CELL_DELETE_BUTTON_WIDTH), self.info.frame.origin.y, BASE_CELL_DELETE_BUTTON_WIDTH, BASE_CELL_DELETE_BUTTON_HEIGH);

    self.line.frame=CGRectMake(BASE_CELL_EDGE, self.bounds.size.height-0.8, VIEW_WIDTH-2*BASE_CELL_EDGE, 0.500001);

}

-(void)deleteBtnTouch
{
    NSLog(@"delete点击");
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

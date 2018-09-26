
//
//  SRCMenuView.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/18.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//



#import "SRCMenuView.h"
#import "SRCMenuItem.h"
#import "SRCDeviceInfo.h"

@interface SRCMenuView()

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)NSMutableArray *items;

@property(nonatomic,assign)BOOL isLeft;
@property(nonatomic,assign)BOOL isRight;

@property(nonatomic,copy)NSArray *data;

@property(nonatomic,strong) SRCMenuItem *selectedItemNow;

@end


@implementation SRCMenuView

#pragma mark public
-(instancetype)initWithFrame:(CGRect)frame leftBtn:(BOOL) leftBtn rightBtn:(BOOL) rightBtn
{
    self=[super initWithFrame:frame];
    self.isLeft=leftBtn;
    self.isRight=rightBtn;
    if(leftBtn)
    {
        [self leftBtn];
    }
    if(rightBtn)
    {
        [self rightBtn];
    }
    //这里加一个下划线
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0,frame.size.height, frame.size.width, 1)];
    [self addSubview:line];
    return self;
}


/**
 *  设置成选中
 *
 */
-(void)setSelectedWithPageIndex:(NSInteger )pageIndex
{
    if(self.items&&[self.items count]>pageIndex)
    {
        if(self.selectedItemNow)
        {
            [self.selectedItemNow setSelected:NO withAnimation:NO];
        }
        SRCMenuItem *item=[self.items objectAtIndex:pageIndex];
        [self scrollToSelectedItem:item];
        [item setSelected:YES withAnimation:YES];
        self.selectedItemNow=item;
    }
}

#pragma mark private
/**
 *  滑动到item居中  的位置
 *
 */
-(void)scrollToSelectedItem:(SRCMenuItem *)item
{
    CGFloat deltax=item.frame.origin.x+item.frame.size.width*0.5;
    if(deltax<=self.frame.size.width*0.5)
    {
        CGPoint point=CGPointMake(0, 0);
        [self.scrollView setContentOffset:point animated:YES];
        return;
    }
    if(deltax>self.frame.size.width*0.5 &&
       deltax+self.frame.size.width*0.5<self.scrollView.contentSize.width)
    {
        CGPoint point=CGPointMake(deltax-self.frame.size.width*0.5, 0);
        [self.scrollView setContentOffset:point animated:YES];
        return;
    }
    if(deltax+self.frame.size.width*0.5>self.scrollView.contentSize.width)
    {
        CGPoint point=CGPointMake(self.scrollView.contentSize.width-self.frame.size.width, 0);
        [self.scrollView setContentOffset:point animated:YES];
        return;
    }
    
}

-(void)reloadDataAndUpdate
{
    if(self.datasource&&[self.datasource respondsToSelector:@selector(numbersOfTitlesInMenuView:)]&&[self.datasource respondsToSelector:@selector(menuView:titleAtIndex:)])
    {
        NSUInteger count=[self.datasource numbersOfTitlesInMenuView:self];
        NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:count];
        for(NSUInteger i=0;i<count;i++)
        {
            NSString *str=[self.datasource menuView:self titleAtIndex:i];
            if(str)
            {
                [arr addObject:str];
            }
        }
        self.data=[arr copy];
        if([arr count]==count)
        {
            [self refreshView];
        }
        
    }
    
}

-(void)refreshView
{
    if(self.items)
    {
        for(int i=0;i<[self.data count];i++)
        {
            if(i<[self.items count])
            {
                SRCMenuItem *item=[self.items objectAtIndex:i];
                item.text=[self.data objectAtIndex:i];
            }
            else
            {
                CGRect frame = CGRectMake(i*SRCITEM_WIDTH, 0, SRCITEM_WIDTH, SRCITEM_HEIGHT);
                __weak typeof(self) weakself=self;
                SRCMenuItem *item=[[SRCMenuItem alloc] initWithFrame:frame selectBlock:^(SRCMenuItem *item) {
                    __strong typeof(weakself) strongself=weakself;
                    
                    if(![strongself.selectedItemNow isEqual:item])
                    {
                        [strongself.selectedItemNow setSelected:NO withAnimation:NO];
                        strongself.selectedItemNow=item;
                        [strongself.selectedItemNow setSelected:YES withAnimation:YES];
                    }
                    
                    
                    if(strongself.delegate&&[strongself.delegate respondsToSelector:@selector(menuView:index:)])
                    {
                        [strongself.delegate menuView:item index:i];
                    }
                }];
                item.text=[self.data objectAtIndex:i];
                if(item)
                {
                    [self.items addObject:item];
                }
            }
        }
        //removeall
        NSArray *views=[self.scrollView subviews];
        for(int i=0;i<[views count];i++)
        {
            UIView *subview=[views objectAtIndex:i];
            [subview removeFromSuperview];
        }
        
        for(int i=0;i<[self.items count];i++)
        {
            SRCMenuItem *ii=[self.items objectAtIndex:i];
            [ii setSelected:NO withAnimation:NO];
            [self.scrollView addSubview:ii];
        }

        self.scrollView.contentSize=CGSizeMake(([self.items count]+1)*SRCITEM_WIDTH, SRCMENUVIEW_HEIGHT);
        
    }
}


#pragma mark -setter/getter
-(NSMutableArray *)items
{
    if(!_items)
    {
        _items=[NSMutableArray new];
    }
    return _items;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        CGRect frame=CGRectMake(VIEW_WIDTH-SRCMENUVIEW_BTN_WIDTH, 0, SRCMENUVIEW_BTN_WIDTH, SRCMENUVIEW_BTN_HEIGHT);
        _rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame=frame;
        [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_rightBtn setImage:[UIImage imageNamed:@"add_channel_titlbar_thin_new_16x16_"] forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"shadow_add_titlebar_new3_52x36_"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnPress) forControlEvents:UIControlEventTouchUpInside];
        if (self.isRight)
        {
            [self addSubview:_rightBtn];
        }
        else
        {
            _rightBtn.hidden=YES;
        }
    }
    return _rightBtn;
}

-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        CGRect frame=CGRectMake(0, 0, SRCMENUVIEW_BTN_WIDTH, SRCMENUVIEW_BTN_HEIGHT);
        _leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame=frame;
        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        
        [_leftBtn setImage:[UIImage imageNamed:@"add_channel_titlbar_thin_new_16x16_"] forState:UIControlStateNormal];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"shadow_add_titlebar_new3_52x36_"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
        if(self.isLeft)
        {
            [self addSubview:_leftBtn];
        }
        else
        {
            _leftBtn.hidden=YES;
        }
    }
    return _leftBtn;
}

-(UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.bounces=YES;
        _scrollView.scrollEnabled=YES;
        [self insertSubview:_scrollView atIndex:0];
    }
    return _scrollView;
}


-(void)leftBtnPress
{
    NSLog(@"左边");
}

-(void)rightBtnPress
{
    NSLog(@"右边");
}






@end

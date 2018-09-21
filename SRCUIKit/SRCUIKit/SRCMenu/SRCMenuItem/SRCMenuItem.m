//
//  SRCMenuItem.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/17.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SRCMenuItem.h"
#import "Error.h"


#define PER_FRAME    16.67

@interface SRCMenuItem()
{
    CGFloat _selectedRed, _selectedGreen, _selectedBlue, _selectedAlpha;
    CGFloat _normalRed, _normalGreen, _normalBlue, _normalAlpha;
    int     _sign;//-1 或者 1
    CGFloat _gap;//差值
    CGFloat _step;//每步 时间
}

@property(nonatomic,copy)void (^selectBlock)(SRCMenuItem *item);
//注意这里为弱引用
@property(nonatomic,weak)CADisplayLink *link;

@end

@implementation SRCMenuItem

-(instancetype)initWithFrame:(CGRect)frame selectBlock:(void (^)(SRCMenuItem *item)) block
{
    self=[self initWithFrame:frame];
    if(self)
    {
        if(block)
        {
            self.selectBlock = block;
        }
    }
    else
    {
        ERROR();
        return nil;
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        //初始化样式
        self.normalSize=15;
        self.selectedSize=18;
        
        self.normalColor=[UIColor blackColor];
        self.selectedColor=[UIColor redColor];
        //设置一些Label 样式
        self.font=[UIFont fontWithName:@"Arial" size:self.normalSize];//设置文字类型与大小
        self.textColor=self.normalColor;
        self.textAlignment=NSTextAlignmentCenter;
        self.numberOfLines=0;//自动换行
        
        //添加点击事件
        UITapGestureRecognizer *gest=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelPress)];
        self.userInteractionEnabled=YES;
        [self addGestureRecognizer:gest];
    }
    return self;
}

#pragma mark set/get
-(void)setRate:(CGFloat)rate
{
    if (rate<0.00)
    {
        rate=0.00;
    }
    if(rate>1.0)
    {
        rate=1.00;
    }
    _rate = rate;
    CGFloat r=_normalRed+(_selectedRed - _normalRed)*rate;
    CGFloat g=_normalGreen+(_selectedGreen-_normalGreen)*rate;
    CGFloat b=_normalBlue+(_selectedBlue-_normalBlue)*rate;
    CGFloat a=_normalAlpha+(_selectedAlpha-_normalAlpha)*rate;
    self.textColor=[UIColor colorWithRed:r green:g blue:b alpha:a];
    CGFloat minScale=self.normalSize/self.selectedSize;
    CGFloat trueScale=minScale+(1-minScale)*rate;
    self.transform=CGAffineTransformMakeScale(trueScale, trueScale);
    
}

-(void)setNormalColor:(UIColor *)normalColor
{
    if(normalColor)
    {
        [normalColor getRed:&_normalRed green:&_normalGreen blue:&_normalBlue alpha:&_normalAlpha];
        _normalColor=normalColor;
    }
}

-(void)setSelectedColor:(UIColor *)selectedColor
{
    if(selectedColor)
    {
        [selectedColor getRed:&_selectedRed green:&_selectedGreen blue:&_selectedBlue alpha:&_selectedAlpha];
        _selectedColor=selectedColor;
    }
}

-(void)setNormalSize:(CGFloat)normalSize
{
    _normalSize=normalSize;
}

-(void)setSelectedSize:(CGFloat)selectedSize
{
    _selectedSize=selectedSize;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected=isSelected;
}

-(CGFloat)speedFactor
{
    if (_speedFactor<=0) {
        _speedFactor=15;
        return _speedFactor;
    }
    return _selectedSize;
}

#pragma mark -public
-(void)setSelected:(BOOL)selected withAnimation:(BOOL)animation
{
    _isSelected=selected;
    if (!animation) {
        self.rate=selected?1.0:0.0;
        return;
    }
    _sign=(selected == YES)?1:-1;
    _gap=(selected == YES)?(1.0-self.rate):(self.rate-0.0);
    _step=_gap/self.speedFactor;
    if (_link)
    {
        [_link invalidate];
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rateChange)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
    
}

-(void)rateChange
{
    if (_gap>0.000001) {
        _gap=_gap-_step;
        if(_gap<=0.0)
        {
            self.rate = (int)(self.rate + _sign * _step + 0.5);
            return;
        }
        self.rate += _sign * _step;
    }
    else
    {
        self.rate = (int)(self.rate + 0.5);
        [_link invalidate];
        _link = nil;
    }
}

//点击处理事件
-(void)labelPress
{
    if(self.selectBlock)
    {
        [self setSelected:YES withAnimation:YES];
        self.selectBlock(self);
    }
}

@end

//
//  SRCPageLayout.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/25.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SRCPageLayout.h"

@interface SRCPageLayout()

//屏幕最多同时出现两个cell
@property(nonatomic,strong)UICollectionViewCell *mainCell;
@property(nonatomic,strong)UICollectionViewCell *nextCell;

@property(nonatomic,strong)NSMutableArray *attributesArray;

@property(nonatomic,copy) void (^pageIndexBlock)(NSInteger pageIndex);

//当前页的索引
@property(nonatomic,assign) NSInteger nowPageIndex;

@end

@implementation SRCPageLayout

#pragma mark public
-(instancetype)initWithPageIndexBlock:(void (^)(NSInteger))block
{
    self=[super init];
    if(self)
    {
        if(block)
        {
            self.pageIndexBlock=block;
        }
    }
    return self;
}



/**
 *  用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 *  每次更新layout布局都会首先调用此方法.
 *
 */
-(void)prepareLayout
{
    self.scrollDirection=UICollectionViewScrollDirectionHorizontal;//水平
    CGFloat width=self.collectionView.frame.size.width;
    CGFloat height=self.collectionView.frame.size.height;
    self.itemSize=CGSizeMake(width, height);//cell 的大小
    
    //计算frame 放到self.attisArr中
    self.attributesArray=[NSMutableArray new];
    //这里是一个section
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (int i =0; i<itemCount; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attribute];
    }
    
    [super prepareLayout];

}

//决定了collectionView停止滚动时的偏移量 这里保证拖动完，显示到一个item的中间
//proposedContentOffset是当前左上角的位移
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //构造当前rect
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    // 获得super已经计算好的布局的属性
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    // 计算 collectionView 最中心点的 x 值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    if([arr count]==0)
    {
        //没有 异常？
    }
    else if([arr count]==1)
    {
        
    }
    else if ([arr count]>1)
    {
        //这里有两个
        UICollectionViewLayoutAttributes *att0=[arr objectAtIndex:0];
        UICollectionViewLayoutAttributes *att1=[arr objectAtIndex:1];
        //距离谁近，就哪个居中
        if(ABS(att0.center.x-centerX)>ABS(att1.center.x-centerX))
        {
            proposedContentOffset=CGPointMake(att1.center.x-self.collectionView.frame.size.width * 0.5, 0);
            
        }
        else
        {
            proposedContentOffset=CGPointMake(att0.center.x-self.collectionView.frame.size.width * 0.5, 0);
        }
    }
    //下取整
    self.nowPageIndex=(int)(proposedContentOffset.x/self.collectionView.frame.size.width);
    if(self.pageIndexBlock)
    {
        self.pageIndexBlock(self.nowPageIndex);
    }
    return proposedContentOffset;

}

//用来创建attribute
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *att=nil;
    if(!self.attributesArray||[self.attributesArray count]==0||[self.attributesArray count]<=indexPath.row)
    {
        // 创建布局属性
        att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat width=self.collectionView.frame.size.width;
        CGFloat height=self.collectionView.frame.size.height;
        att.frame=CGRectMake(indexPath.row*width, 0, width, height);
        //att.hidden=NO;
    }
    else
    {
        att=[self.attributesArray objectAtIndex:indexPath.row];
    }
    return att;
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 * 1.prepareLayout
 * 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}





@end

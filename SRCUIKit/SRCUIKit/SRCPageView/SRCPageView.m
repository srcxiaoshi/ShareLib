//
//  SRCPageView.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/21.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SRCPageView.h"
#import "SRCPageLayout.h"
#import "SRCPageViewCell.h"
#import "Error.h"

@interface SRCPageView()<UICollectionViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) SRCPageLayout *layout;

@property(nonatomic,assign) NSInteger count;

@end

@implementation SRCPageView



-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor=[UIColor whiteColor];
        __weak typeof(self) weakself=self;
        self.layout=[[SRCPageLayout alloc] initWithPageIndexBlock:^(NSInteger pageIndex) {
            
            if(weakself.delegate && [weakself.delegate respondsToSelector:@selector(SRCPageView:pageIndex:)])
            {
                [weakself.delegate SRCPageView:weakself.collectionView pageIndex:pageIndex];
            }
            
        }];
        self.layout.itemSize=CGSizeMake(frame.size.width, frame.size.height);
        self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:self.layout];
        self.collectionView.backgroundColor=[UIColor whiteColor];
        self.collectionView.dataSource=self;
        self.collectionView.delegate=self;
        self.collectionView.showsHorizontalScrollIndicator=NO;
        [self addSubview:self.collectionView];
        //注册
        [self.collectionView registerClass:[SRCPageViewCell class] forCellWithReuseIdentifier:SRCPageViewCellDefaultID];
    }
    
    return self;
}



#pragma mark datasource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.delegate && [[self delegate] respondsToSelector:@selector(SRCPageViewNumberOfItems:)])
    {
        NSInteger count=[self.delegate SRCPageViewNumberOfItems:self.collectionView];
        if(count)
        {
            self.count=count;
            return count;
        }
        else
        {
            self.count=0;
            return 0;
        }
    }
    else
    {
        self.count=0;
        return 0;
    }
    
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(SRCPageView:cellForItemAtIndexPath:)])
    {
        SRCPageViewCell *cell=[self.delegate SRCPageView:self.collectionView cellForItemAtIndexPath:indexPath];
        return cell;
    }
    else
        return [collectionView dequeueReusableCellWithReuseIdentifier:SRCPageViewCellDefaultID forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(SRCPageView:didSelectItemAtIndexPath:)])
    {
        [self.delegate SRCPageView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }
}


#pragma mark -public
-(void)refreshViewWithCallBack:(void (^)(void)) block
{
    __weak typeof(self) weakself=self;
    [self.collectionView performBatchUpdates:^{
        __strong typeof(weakself) strongself=weakself;
        [strongself.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:^(BOOL finished) {
        if(block)
        {
            block();
        }
    }];
}

-(void)scollToItemWithPageIndex:(NSInteger)pageIndex animated:(BOOL) animated
{
    if(self.count>pageIndex)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:pageIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
    else
    {
        ERROR();
    }
}

@end

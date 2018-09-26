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

@interface SRCPageView()<UICollectionViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UICollectionView *collectionView;

@end

@implementation SRCPageView

static NSString * const cellID=@"SRCCollectionViewCell";

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor=[UIColor blueColor];
        SRCPageLayout *layout=[[SRCPageLayout alloc] init];
        layout.itemSize=CGSizeMake(frame.size.width, frame.size.height);
        self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        self.collectionView.dataSource=self;
        self.collectionView.delegate=self;
        self.collectionView.showsHorizontalScrollIndicator=NO;
        [self addSubview:self.collectionView];
        //注册
        [self.collectionView registerClass:[SRCPageViewCell class] forCellWithReuseIdentifier:cellID];
    }
    
    return self;
}

#pragma mark datasource


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SRCPageViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了%@",indexPath);
}




@end

//
//  SRCMenuView.h
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/18.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRCMenuItem.h"

@class SRCMenuView;

@protocol SRCMenuViewDataSource<NSObject>
@required
- (NSInteger)numbersOfTitlesInMenuView:(SRCMenuView *)menu;
- (NSString *)menuView:(SRCMenuView *)menu titleAtIndex:(NSInteger)index;
@end

@protocol SRCMenuViewDelegate<NSObject>
@optional
-(void)menuView:(SRCMenuItem *)item;
@end



@interface SRCMenuView : UIView

@property(nonatomic,weak)id<SRCMenuViewDataSource> datasource;

@property(nonatomic,weak)id<SRCMenuViewDelegate> delegate;

/**
 *  初始化方法
 *
 */
-(instancetype)initWithFrame:(CGRect)frame leftBtn:(BOOL) leftBtn rightBtn:(BOOL) rightBtn;

/**
 *  更新数据，并刷新
 *
 */
-(void)reloadDataAndUpdate;

@end


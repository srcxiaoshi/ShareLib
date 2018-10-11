//
//  SRCTableView.h
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/26.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import <UIKit/UIKit.h>

//cell 样式定义标识 用于扩展
static NSString * const SRCTableViewCellDefaultID=@"SRCTableViewCellDefaultID";






@class SRCTableView;

@protocol SRCTableViewDelegate<NSObject>
@required

/**
 * section 数目
 */
- (NSInteger)numberOfSectionsInSRCTableView:(UITableView *)tableView;

/**
 * cell数目
 */
- (NSInteger)SRCTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/**
 * cell样式
 */
- (UITableViewCell *)SRCTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * cell点击事件
 */
- (void)SRCTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * cell高度
 */
-(CGFloat)SRCTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface SRCTableView : UIView

@property(nonatomic,weak)id<SRCTableViewDelegate> delegate;

-(void)reloadData;
@end

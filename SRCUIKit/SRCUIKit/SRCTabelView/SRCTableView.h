//
//  SRCTableView.h
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/26.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import <UIKit/UIKit.h>

//cell 样式定义标识 用于扩展
static NSString * const defaultCellID=@"SRCTableViewCellDefaultID";






@class SRCTableView;

@protocol SRCTableViewDelegate<NSObject>
@required

/**
 * section 数目
 */
- (NSInteger)numberOfSectionsInSRCTableView:(SRCTableView *)tableView;

/**
 * cell数目
 */
- (NSInteger)SRCTableView:(SRCTableView *)tableView numberOfRowsInSection:(NSInteger)section;

/**
 * cell样式
 */
- (UITableViewCell *)SRCTableView:(SRCTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * cell点击事件
 */
- (void)SRCTableView:(SRCTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SRCTableView : UIView

@property(nonatomic,weak)id<SRCTableViewDelegate> delegate;


@end

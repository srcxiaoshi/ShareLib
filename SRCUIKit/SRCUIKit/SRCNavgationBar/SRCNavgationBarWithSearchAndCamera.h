//
//  NavgationBarWithSearchAndCamera.h
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/15.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImagePressBlock)(void);
typedef void(^SearchTextFieldBlock)(void);


@interface SRCNavgationBarWithSearchAndCamera : UINavigationBar

/**
 * 此block回调camera点击事件
 *
 */
@property(nonatomic,copy)ImagePressBlock imagePressBlock;


/**
 * 此block回调textFieldShouldBeginEditing事件
 *
 */
@property(nonatomic,copy)SearchTextFieldBlock searchTextBlock;


@end

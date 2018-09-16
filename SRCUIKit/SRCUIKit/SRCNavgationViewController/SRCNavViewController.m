//
//  NavViewController.m
//  News
//  此类用于衔接Tab和vc
//  Created by 史瑞昌 on 2018/9/14.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SRCNavViewController.h"
#import "UIImage+Color.h"

@interface SRCNavViewController ()

@end

@implementation SRCNavViewController

-(instancetype)init
{
    self=[super init];
    if(self)
    {
        //NavigationBar的title字体大小 bar背景颜色 黑色
        [[UINavigationBar appearance] setTranslucent:NO];
        NSMutableDictionary * color = [NSMutableDictionary new];
        [color setObject:[UIFont systemFontOfSize:16.0f] forKey:NSFontAttributeName];
        [color setObject:[UIColor blackColor] forKey:NSBackgroundColorAttributeName];
        [[UINavigationBar appearance] setTitleTextAttributes:color];
        
        //控制器返回按钮 item 字体与颜色
        UIBarButtonItem * item = [UIBarButtonItem appearance];
        NSMutableDictionary * atts = [NSMutableDictionary new];
        [atts setObject:[UIFont systemFontOfSize:15.0f] forKey:NSFontAttributeName];
        [item setTitleTextAttributes:atts forState:UIControlStateNormal];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithRed:0.83 green:0.24 blue:0.24 alpha:1.0] forBarMetrics:UIBarMetricsDefault];
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //不能直接用self.navigationBarHidden = YES来隐藏导航栏，因为用这个属性的话，系统默认的右滑返回手势就没有了，切记，一定要用self.navigationBar.hidden = YES来隐藏，并将self.navigationBarHidden的值设为YES（默认就是YES，所以可以不用加这句）。
    self.navigationBarHidden=NO;// 使右滑返回手势可用
    self.navigationBar.hidden=YES;// 隐藏导航栏
}

#pragma overwrite
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //这里是ios7 以后，push 后隐藏tabBar
    if([[self childViewControllers] count]>=1)
    {
        viewController.hidesBottomBarWhenPushed=YES;
    }
    //自定义动画，或者优化的push时间
    if (animated)
    {
        //这里使用转场动画，然后调用没有动画的push
        CATransition *animation = [CATransition animation];
        animation.duration = 0.4f;//400ms
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        //将新的动画，添加到navController
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
        //将新的动画，添加到viewController
        [self.view.layer addAnimation:animation forKey:nil];
        //无动画切换vc
        [super pushViewController:viewController animated:NO];
        
        return;
    }
    
    [super pushViewController:viewController animated:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

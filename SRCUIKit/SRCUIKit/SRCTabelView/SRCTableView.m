//
//  SRCTableView.m
//  SRCUIKit
//
//  Created by 史瑞昌 on 2018/9/26.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SRCTableView.h"

@interface SRCTableView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end




@implementation SRCTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        [self addSubview:self.tableView];
        
        //注册默认 cell样式
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultCellID];
    }
    return self;
}

#pragma mark datasource/delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(SRCTableView:numberOfRowsInSection:)])
    {
        return [self.delegate numberOfSectionsInSRCTableView:self];
    }
    else
    {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(SRCTableView:numberOfRowsInSection:)])
    {
        return [self.delegate SRCTableView:self numberOfRowsInSection:section];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(SRCTableView:cellForRowAtIndexPath:)])
    {
        return [self.delegate SRCTableView:self cellForRowAtIndexPath:indexPath];
    }
    else
    {
        return [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(SRCTableView:didSelectRowAtIndexPath:)])
    {
        [self.delegate SRCTableView:self didSelectRowAtIndexPath:indexPath];
    }

}


@end
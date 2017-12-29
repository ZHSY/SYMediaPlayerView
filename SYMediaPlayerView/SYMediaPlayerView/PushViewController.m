//
//  PushViewController.m
//  SYMediaPlayerView
//
//  Created by 夜雨 on 16/8/30.
//  Copyright © 2016年 yeyu. All rights reserved.
//

#import "PushViewController.h"

#import "UIView+SYExtend.h"

#import "SYMediaPlayerView.h"


#define TopMargin 20

#define MinPlayerHeight (kDWidth / 16 * 9)



@interface PushViewController()


@property (nonatomic, strong)SYMediaPlayerView  *playerView;
@property (nonatomic, strong)UIView             *headerView;


@end

@implementation PushViewController




- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDWidth, MinPlayerHeight + TopMargin)];
    _headerView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_headerView];
    
    NSString *mvUrl = @"http://7rfkz6.com1.z0.glb.clouddn.com/480p_150902_jianguoshouji.mp4"; 
    
    _playerView = [[SYMediaPlayerView alloc] initWithFrame:CGRectMake(0, TopMargin, kDWidth, MinPlayerHeight) uRL:[NSURL URLWithString:mvUrl] title:@"这是视频标题"];
    [_headerView addSubview:_playerView];
    

    
    _playerView;
    
    
    
    
    
}






    
















@end

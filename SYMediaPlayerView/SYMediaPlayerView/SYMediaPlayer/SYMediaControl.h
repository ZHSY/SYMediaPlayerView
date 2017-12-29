//
//  XZYMediaControl.h
//  XzyDoctor
//
//  Created by 张双义 on 16/8/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol IJKMediaPlayback;

@protocol SYMediaControlDelegate <NSObject>

- (void)onClickFullscreen:(BOOL)isFull;
- (void)onClickMediaControl:(id)sender;

- (void)onClickHUD:(id)sender;
- (void)onClickDone:(id)sender;
- (void)onClickPlayButton:(id)sender;


- (void)didSliderTouchUpInside;
- (void)didSliderValueChanged;

@end

@interface SYMediaControl : UIView


- (void)showAndFade;
- (void)hide;
- (void)refreshMediaControl;

- (void)beginDragMediaSlider;
- (void)endDragMediaSlider;
- (void)continueDragMediaSlider;

/**
 *  播放失败
 */
- (void)failPlayVideo;

@property (nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;
@property (nonatomic, weak) id<SYMediaControlDelegate>delegate;



@property (nonatomic, assign)BOOL autoHideCloseBtn;//是否竖屏状态下隐藏自带的关闭按钮
@property (nonatomic, assign)BOOL showHUDInfo;//是否显示HUD信息按钮
@property (nonatomic, assign)BOOL isFullscreen;//标示是否处于全屏状态


@property (nonatomic, assign)BOOL hasTopMargin;//是否头部预留电池栏高度

@property (nonatomic, assign)BOOL showCenterPlayBtn;//是否显示中心 播放状态按钮 默认

@property (nonatomic, assign)BOOL showActivite;//显示进度条


@property (nonatomic, strong, readonly) UIView    *overlayPanel;


@property (nonatomic, strong, readonly) UIView    *topPanel;
@property (nonatomic, strong, readonly) UIButton  *closeBtn;
@property (nonatomic, strong, readonly) UILabel   *titleLabel;


@property (nonatomic, strong, readonly) UIView    *bottomPanel;
@property (nonatomic, strong, readonly) UIButton  *playButton;
@property (nonatomic, strong, readonly) UILabel   *currentTimeLabel;
@property (nonatomic, strong, readonly) UILabel   *totalDurationLabel;
@property (nonatomic, strong, readonly) UISlider  *mediaProgressSlider;

@property (nonatomic, strong, readonly) UIButton  *fullScreenBtn;

@property (nonatomic, strong, readonly) UIButton  *hudInfoBtn;




@end

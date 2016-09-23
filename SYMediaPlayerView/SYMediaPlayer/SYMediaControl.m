//
//  XZYMediaControl.m
//  XzyDoctor
//
//  Created by 张双义 on 16/8/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SYMediaControl.h"
#import "UIView+SYExtend.h"

#import <IJKMediaFramework/IJKMediaFramework.h>



#define MARGIN		5

#define HEAD_H		44

#define LABEL_W		45
#define LABEL_H		(HEAD_H - 2*MARGIN)
#define BTN_H		(HEAD_H - 2*MARGIN)






@interface SYMediaControl()

@property (nonatomic, strong) UIView    *overlayPanel;


@property (nonatomic, strong) UIView    *topPanel;
@property (nonatomic, strong) UIButton  *closeBtn;
@property (nonatomic, strong) UILabel   *titleLabel;


@property (nonatomic, strong) UIView    *bottomPanel;
@property (nonatomic, strong) UIButton  *playButton;
@property (nonatomic, strong) UILabel   *currentTimeLabel;
@property (nonatomic, strong) UILabel   *totalDurationLabel;
@property (nonatomic, strong) UISlider  *mediaProgressSlider;

@property (nonatomic, strong) UIButton  *fullScreenBtn;


@property (nonatomic, strong) UIButton  *hudInfoBtn;
@property (nonatomic, strong) UIButton  *centerPlayBtn;


@property (nonatomic, strong) UIActivityIndicatorView *activiteView;



@property (strong, nonatomic) id        appBackstageObserver;

@end


@implementation SYMediaControl

{
    BOOL _isMediaSliderBeingDragged;
}

#pragma mark - publick

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        
        [self creatSubviews];
        [self refreshMediaControl];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        
        [self addGestureRecognizer:gesture];
        
        //添加进入后台的监听
        [self addAppBackstageObserverForPlayer];
    }
    return self;
}


- (void)showNoFade
{
    
    self.topPanel.hidden = NO;
    self.bottomPanel.hidden = NO;
    
    [self cancelDelayedHide];
    [self refreshMediaControl];
    [self performSelector:@selector(hide) withObject:nil afterDelay:5];
}

- (void)showAndFade
{
    if (self.bottomPanel.hidden) {
        
        [self showNoFade];
    }else{
        [self hide];
    }
}

- (void)hide
{
    
    self.topPanel.hidden = YES;
    self.bottomPanel.hidden = YES;
    [self cancelDelayedHide];
}

- (void)refreshMediaControl
{
    // duration
    NSTimeInterval duration = self.delegatePlayer.duration;
    NSInteger intDuration = duration + 0.5;
    if (intDuration > 0) {
        self.mediaProgressSlider.maximumValue = duration;
        self.totalDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    } else {
        self.totalDurationLabel.text = @"--:--";
        self.mediaProgressSlider.maximumValue = 1.0f;
    }
    
    
    // position
    NSTimeInterval position;
    if (_isMediaSliderBeingDragged) {
        position = self.mediaProgressSlider.value;
    } else {
        position = self.delegatePlayer.currentPlaybackTime;
        
        if (intDuration > 0) {
            self.mediaProgressSlider.value = position;
        } else {
            self.mediaProgressSlider.value = 0.0f;
        }
    }
    
    NSInteger intPosition = position + 0.5;
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
    
    
    // status
    BOOL isPlaying = [self.delegatePlayer isPlaying];
    self.playButton.selected = isPlaying;
    _centerPlayBtn.hidden = (isPlaying || [self.activiteView isAnimating]);
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    if (!self.bottomPanel.hidden && self.delegatePlayer) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
}

- (void)beginDragMediaSlider
{
    _isMediaSliderBeingDragged = YES;
}

- (void)endDragMediaSlider
{
    _isMediaSliderBeingDragged = NO;
}

- (void)continueDragMediaSlider
{
    [self refreshMediaControl];
}


/**
 *  播放失败
 */
- (void)failPlayVideo
{
    //停止状态刷新
    [self cancelDelayedRefresh];
    self.playButton.selected = NO;
    self.showActivite = NO;
    /**
     *  移除手势响应
     */
    for (UIGestureRecognizer *gesture in [self gestureRecognizers]) {
        [self removeGestureRecognizer:gesture];
    }
    
    /**
     *  禁用底部控制栏
     */
    self.bottomPanel.userInteractionEnabled = NO;
    
}


#pragma mark - UI

- (void)creatSubviews
{
    self.overlayPanel = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.overlayPanel];
    
    
    /**
     *  头视图
     */
    self.topPanel = ({
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        
        header;
        
    });
    [self.overlayPanel addSubview:self.topPanel];
    
    
    self.closeBtn = ({
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn setImage:[UIImage imageNamed:@"backbtn"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(onClickDone) forControlEvents:UIControlEventTouchUpInside];
        closeBtn;
    });
    [self.topPanel addSubview:self.closeBtn];
    
    self.titleLabel = ({
        
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:14];
        [title setTextColor:[UIColor whiteColor]];
        title;
        
    });
    [self.topPanel addSubview:self.titleLabel];
    
    
    
    /**
     *  尾视图
     */
    self.bottomPanel = ({
        
        UIView *footer = [[UIView alloc] init];
        
        footer.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        
        footer.userInteractionEnabled = YES;
        footer;
        
    });
    [self.overlayPanel addSubview:self.bottomPanel];
    
    
    self.playButton = ({
        
        UIButton *playBtn = [[UIButton alloc] init];
        [playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        
        [playBtn addTarget:self action:@selector(playControl) forControlEvents:UIControlEventTouchUpInside];
        playBtn;
    });
    [self.bottomPanel addSubview:self.playButton];
    
    
    self.currentTimeLabel  = ({
        
        UILabel *label	= [[UILabel alloc] init];
        label.font		= [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:[UIColor whiteColor]];
        
        label;
    });
    [self.bottomPanel addSubview:self.currentTimeLabel];
    
    
    self.totalDurationLabel = ({
        
        UILabel *label	= [[UILabel alloc] init];
        label.font		= [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:[UIColor whiteColor]];
        
        label;
        
    });
    [self.bottomPanel addSubview:self.totalDurationLabel];
    
    
    self.mediaProgressSlider = ({
        
        UISlider *slider = [[UISlider alloc] init];
        slider.minimumValue = 0.0;
        slider.maximumValue = 1.0;
        [slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        [slider addTarget:self action:@selector(slideTouchDown) forControlEvents:UIControlEventTouchDown];
        [slider addTarget:self action:@selector(slideTouchCancel) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        [slider addTarget:self action:@selector(slideTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        
        [slider addTarget:self action:@selector(slideValueChanged) forControlEvents:UIControlEventValueChanged];
        
        
        
        slider;
    });
    [self.bottomPanel addSubview:self.mediaProgressSlider];
    
    
    self.fullScreenBtn = ({
        UIButton *btn		= [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"shrinkscreen"] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [self.bottomPanel addSubview:self.fullScreenBtn];
    
    
    self.activiteView = ({
        
        UIActivityIndicatorView *activiteView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];//UIActivityIndicatorViewStyleWhiteLarge
        activiteView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        
        activiteView.size = CGSizeMake(40, 40);
        [activiteView stopAnimating];
        
        activiteView;
        
    });
    [self.overlayPanel addSubview:self.activiteView];
    
    
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    // 0. |c|s|t|y|
    
    CGFloat mWidth = self.width;
    self.overlayPanel.frame = self.bounds;
    
    CGFloat topHeight = HEAD_H;
    CGFloat topMaigin = MARGIN;
    if (_hasTopMargin) {
        topHeight += 20;
        topMaigin = topHeight - BTN_H - MARGIN;
    }
    
    self.topPanel.frame = CGRectMake(0, 0, mWidth, topHeight);
    self.closeBtn.frame = CGRectMake(MARGIN, topMaigin, BTN_H,  BTN_H);
    
    CGFloat ttW = mWidth - _closeBtn.right - 2*MARGIN;
    if (self.showHUDInfo) {
        self.hudInfoBtn.frame = CGRectMake(mWidth - MARGIN, topMaigin, LABEL_W, BTN_H);
        ttW = ttW - self.hudInfoBtn.width - MARGIN;
    }
    
    self.titleLabel.frame = CGRectMake(_closeBtn.right + MARGIN, topMaigin, ttW, LABEL_H);
    
    
    
    // bottom
    self.bottomPanel.frame = CGRectMake(0,self.height - HEAD_H, mWidth, HEAD_H);
    
    
    self.playButton.frame = CGRectMake(MARGIN, MARGIN, BTN_H, BTN_H);
    self.fullScreenBtn.frame = CGRectMake(mWidth - HEAD_H, 0, HEAD_H, HEAD_H);
    
    self.currentTimeLabel.frame = CGRectMake(self.playButton.right + MARGIN, MARGIN, LABEL_W, LABEL_H);
    
    CGFloat ttLeft = self.fullScreenBtn.left - MARGIN - LABEL_W;
    self.totalDurationLabel.frame = CGRectMake(ttLeft, MARGIN, LABEL_W, LABEL_H);
    
    // sliderView
    CGFloat slidW = ttLeft - 2*MARGIN - self.currentTimeLabel.right;
    self.mediaProgressSlider.frame = CGRectMake(self.currentTimeLabel.right + MARGIN, MARGIN, slidW, LABEL_H);
    
    if (self.autoHideCloseBtn &&! _isFullscreen) {
        self.closeBtn.hidden = YES;
    }else{
        self.closeBtn.hidden = NO;
    }
    
    if (_showCenterPlayBtn) {
        _centerPlayBtn.frame = [UIView frameWithW:HEAD_H h:HEAD_H center:self.overlayPanel.insideCenter];
    }
    
    
    self.activiteView.center = self.overlayPanel.insideCenter;
    
    
    //    if (self.player.isFullScreen && self.bounds.size.width > 500) {
    //        self.headerView.hidden = NO;
    //    } else {
    //        self.headerView.hidden = YES;
    //    }
    
    
    
}

#pragma mark - Action


- (void)tapClick
{
    //    if (_mediaProgressSlider) {
    //        return;
    //    }
    if ([self.delegate respondsToSelector:@selector(onClickMediaControl:)]) {
        [self.delegate onClickMediaControl:self];
    }
    
}

- (void)onClickDone
{
    self.centerPlayBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(onClickDone:)]) {
        [self.delegate onClickDone:self.closeBtn];
    }
    
}

- (void)onClickHUD
{
    if ([self.delegate respondsToSelector:@selector(onClickHUD:)]) {
        [self.delegate onClickDone:self.hudInfoBtn];
    }
    
}

- (void)fullScreen
{
    
    self.fullScreenBtn.selected = !self.fullScreenBtn.selected;
    
    
    if ([self.delegate respondsToSelector:@selector(onClickFullscreen:)]) {
        [self.delegate onClickFullscreen:self.fullScreenBtn.selected];
    }
    
    self.isFullscreen = self.fullScreenBtn.selected;
}

- (void)playControl
{
    _centerPlayBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(onClickPlayButton:)]) {
        [self.delegate onClickPlayButton:self.playButton];
    }
}


- (void)slideTouchDown
{
    [self beginDragMediaSlider];
}

- (void)slideTouchCancel
{
    [self endDragMediaSlider];
}

- (void)slideTouchUpInside
{
    if ([self.delegate respondsToSelector:@selector(didSliderTouchUpInside)]) {
        [self.delegate didSliderTouchUpInside];
    }
}

- (void)slideValueChanged
{
    
    [self showNoFade];
    if ([self.delegate respondsToSelector:@selector(didSliderValueChanged)]) {
        [self.delegate didSliderValueChanged];
    }
    
}


#pragma mark set/get

- (void)setShowHUDInfo:(BOOL)showHUDInfo
{
    if (showHUDInfo && !_hudInfoBtn) {
        
        _hudInfoBtn = [[UIButton alloc] init];
        [_hudInfoBtn setTitle:@"HUD信息" forState:UIControlStateNormal];
        
        [_hudInfoBtn addTarget:self action:@selector(onClickHUD) forControlEvents:UIControlEventTouchUpInside];
        [self.topPanel addSubview:_hudInfoBtn];
        
        
    }else if (_hudInfoBtn){
        _hudInfoBtn.hidden = !showHUDInfo;
    }
    
    _showHUDInfo = showHUDInfo;
    
}

- (void)setShowCenterPlayBtn:(BOOL)showCenterPlayBtn
{
    if (_showCenterPlayBtn == showCenterPlayBtn) {
        return;
    }
    
    _showCenterPlayBtn = showCenterPlayBtn;
    
    if (showCenterPlayBtn &&  !_centerPlayBtn) {
        _centerPlayBtn = ({
            
            UIButton *playBtn = [[UIButton alloc] init];
            [playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            [playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
            
            [playBtn addTarget:self action:@selector(playControl) forControlEvents:UIControlEventTouchUpInside];
            playBtn;
        });
        
        [self.overlayPanel addSubview:_centerPlayBtn];
        
    }
    
    
    
    _centerPlayBtn.hidden = !showCenterPlayBtn;
    
    
}

- (void)setShowActivite:(BOOL)showActivite
{
    if (showActivite) {
        self.centerPlayBtn.hidden = YES;
        [_activiteView startAnimating];
    }else{
        [_activiteView stopAnimating];
    }
    
}

- (void)setIsFullscreen:(BOOL)isFullscreen
{
    if (_isFullscreen != isFullscreen) {
        _isFullscreen = isFullscreen;
        _fullScreenBtn.selected = isFullscreen;
    }
}

#pragma mark - pravite


//要进入后台
- (void)addAppBackstageObserverForPlayer
{
    NSString *name = UIApplicationWillResignActiveNotification;
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    __weak typeof(self) weakSelf = self;
    void (^callback)(NSNotification *note) = ^(NSNotification *notification) {
        NSLog(@"======播放器进入后台");
        
        if (weakSelf.delegatePlayer) {
            
            [weakSelf.delegatePlayer pause];
            
            weakSelf.topPanel.hidden = NO;
            weakSelf.bottomPanel.hidden = NO;
            weakSelf.centerPlayBtn.hidden = NO;
            weakSelf.playButton.selected = NO;
            weakSelf.showActivite = NO;
            
            [weakSelf cancelDelayedHide];
            [weakSelf cancelDelayedRefresh];
        }
        
    };
    
    self.appBackstageObserver =
    [[NSNotificationCenter defaultCenter] addObserverForName:name
                                                      object:self.delegatePlayer
                                                       queue:queue
                                                  usingBlock:callback];
}


- (void)cancelDelayedHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
}

- (void)cancelDelayedRefresh
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
}


- (void)dealloc
{
    if (self.appBackstageObserver) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self.appBackstageObserver
                      name:UIApplicationWillResignActiveNotification
                    object:nil];
        self.appBackstageObserver = nil;
    }
}

@end

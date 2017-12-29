//
//  SYCommendView.h
//  DGThumbUpButton
//
//  Created by 张双义 on 16/8/5.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,SYCommendViewType) {
    SYCommendViewTypeImage,
    SYCommendViewTypeLabel
};


typedef NS_ENUM(NSUInteger,SYCommendViewStyle) {
    SYCommendViewStyleDefault,
    SYCommendViewStyleShowAll       = 0,
    SYCommendViewStyleLessTan100,
    SYCommendViewStyleLessTan1000
};

NS_ASSUME_NONNULL_BEGIN

@class SYCommendView;

@interface SYCommendView : UIView

@property (nonatomic, assign, readwrite) NSInteger          commentNumber;
@property (nonatomic, assign, readonly)  SYCommendViewType  viewType;
@property (nonatomic, assign, readwrite) SYCommendViewStyle viewStyle;

@property (nonatomic, copy) void(^commentBlock)(SYCommendView *);


- (instancetype)initWithFrame:(CGRect)frame viewType:(SYCommendViewType)viewType;


- (void)setCommentBlock:(void (^ _Nonnull)(SYCommendView * _Nonnull commendView))commentBlock;


- (void)setSelected:(BOOL)selected;



NS_ASSUME_NONNULL_END






@end

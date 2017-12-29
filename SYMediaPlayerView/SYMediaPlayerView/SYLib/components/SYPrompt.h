//
//  SYPrompt.h
//  XzyPatient
//
//  Created by 张双义 on 16/8/5.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface SYPrompt : NSObject


#pragma mark - 消息提示

/**
 *  弹出消息 自动隐藏
 *
 *  默认位置 靠近底部
 *
 *  @param message 消息内容
 */
+ (void)showMessage:(NSString *)message;
+ (void)showMessageTop:(NSString *)message;
+ (void)showMessageMiddle:(NSString *)message;
/**
 *  弹出消息 自动隐藏
 *
 *  @param message  消息内容
 *  @param location 消息出现的位置
 */
+ (void)showMessage:(NSString *)message topMargin:(CGFloat)margin;



/**
 *  自动隐藏的消息提示 _新
 */
+ (void)showMessage:(NSString *)message onView:(UIView *)parentView;


#pragma mark - Alert

/**
 *  弹窗提示 默认关闭按钮：确定
 *
 *  @param message 提示内容
 */
+ (void)showAlertMessage:(NSString *)message;
/**
 *  弹窗提示
 *
 *  @param message 提示内容
 *  @param title   关闭按钮的title
 */
+ (void)showAlertMessage:(NSString *)message sureBtnTitle:(NSString *)title;




@end

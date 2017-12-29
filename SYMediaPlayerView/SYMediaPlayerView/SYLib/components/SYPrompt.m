//
//  SYPrompt.m
//  XzyPatient
//
//  Created by 张双义 on 16/8/5.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SYPrompt.h"

#import "UIView+SYExtend.h"

@implementation SYPrompt


#pragma mark - 消息提示

//自动隐藏消息
+(void)showMessage:(NSString *)message
{
    [self showMessageMiddle:message];
    
}

+ (void)showMessageTop:(NSString *)message
{
    [self showMessage:message topMargin:100];
}
+ (void)showMessageMiddle:(NSString *)message
{
    [self showMessage:message topMargin:kDHeight/2];
}

+ (void)showMessage:(NSString *)message topMargin:(CGFloat)margin
{
    
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor darkGrayColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 10.0f;
    showview.layer.masksToBounds = YES;
    
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    label.frame = CGRectMake(15, 8, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:15];
    
    [showview addSubview:label];
    
    CGRect frame = CGRectMake((kDWidth - LabelSize.width - 30)/2, margin, LabelSize.width+30, LabelSize.height+16);
    __block UIWindow *window = [[UIWindow alloc]initWithFrame:frame];
    window.windowLevel = 9999999+1;
    
    showview.frame =  window.bounds;
    [window addSubview:showview];
    [window makeKeyAndVisible];//关键语句,显示window
    
    
    [UIView animateWithDuration:3.5 animations:^{
        showview.alpha = 0;
    }];
    
    // 延迟2秒执行：
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [window resignKeyWindow];
        window = nil;
    });
    
}

/**
 *  自动隐藏的消息提示
 */
+ (void)showMessage:(NSString *)message onView:(UIView *)parentView;
{
    
    
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor darkGrayColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 10.0f;
    showview.layer.masksToBounds = YES;
    [parentView addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    label.frame = CGRectMake(15, 8, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:15];
    
    CGRect frame = CGRectMake((kDWidth - LabelSize.width - 30)/2, parentView.frame.size.height/2 - (LabelSize.height+16)/2, LabelSize.width+30, LabelSize.height+16);
    showview.frame =  frame;
    
    [showview addSubview:label];
    
    
    [UIView animateWithDuration:3.5 animations:^{
        showview.alpha = 0;
    } completion:nil];
    
    // 延迟2秒执行：
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [showview removeFromSuperview];
    });
    
    
}
#pragma mark - Alert

//弹出弹窗
+ (void)showAlertMessage:(NSString *)message
{
    [self showAlertMessage:message sureBtnTitle:@"确定"];
}

+ (void)showAlertMessage:(NSString *)message sureBtnTitle:(NSString *)title
{
    if (message && ![message isEqualToString:@""]) {
        
        
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertCtrl addAction:okAction];
            [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertCtrl animated:YES completion:nil];
            
        }else{
            //这个else一定要写，否则会导致在ios8以下的真机crash
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        return;
    }
    
}



@end

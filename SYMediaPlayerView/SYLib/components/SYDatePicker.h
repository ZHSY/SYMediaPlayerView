//
//  SYDatePicker.h
//  XzyPatient
//
//  Created by 张双义 on 16/8/1.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SYDatePickerChangeBlock)(BOOL isChange, NSDate *date);


@interface SYDatePicker : UIView

@property (nonatomic, strong, readonly)UIDatePicker *datePicker;
@property (nonatomic, strong, readonly)UIView       *toolBarView;




+ (instancetype)datePickerWithMode:(UIDatePickerMode )pickerMode actionBlock:(SYDatePickerChangeBlock)actionBlock;


@end

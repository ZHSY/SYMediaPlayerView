//
//  SYDatePicker.m
//  XzyPatient
//
//  Created by 张双义 on 16/8/1.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SYDatePicker.h"
#import "UIView+SYExtend.h"
#import "Tool_ZSY.h"

#define Height_DatePick 200
#define Height_ToolBar 40

#define Width_ToolBarBtn 80

#define TooBarTag_Cancel 1
#define TooBarTag_Submit 2

@interface SYDatePicker()

@property (nonatomic, copy)SYDatePickerChangeBlock  dateChangeBlock;

@property (nonatomic, strong, readwrite)UIDatePicker   *datePicker;
@property (nonatomic, strong, readwrite)UIView         *toolBarView;


@end

@implementation SYDatePicker

+ (instancetype)datePickerWithMode:(UIDatePickerMode)pickerMode actionBlock:(SYDatePickerChangeBlock)actionBlock
{
    SYDatePicker *datePicker  = [[SYDatePicker alloc] initWithFrame:CGRectMake(0, 0, kDWidth, Height_ToolBar+ Height_DatePick)];
    
    datePicker.datePicker.datePickerMode = pickerMode;
    datePicker.dateChangeBlock = actionBlock;
    
    return datePicker;

}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self creatSubViews];
    }
    
    return self;
}





#pragma mark - pravite


- (void)creatSubViews
{
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.height -Height_DatePick, kDWidth, Height_DatePick)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.minuteInterval = 1;
    
    
    _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.top - Height_ToolBar, kDWidth, Height_ToolBar)];
    
    _toolBarView.backgroundColor = [Tool_ZSY colorWithHexString:@"#F0F2F5"];//COLOR_LINE; //

    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Width_ToolBarBtn, _toolBarView.height)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.tag = TooBarTag_Cancel;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn addTarget:self action:@selector(tooBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(_toolBarView.width - Width_ToolBarBtn, 0, Width_ToolBarBtn, _toolBarView.height)];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    submitBtn.tag = TooBarTag_Submit;
    [submitBtn addTarget:self action:@selector(tooBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _toolBarView.width, 1)];
    lineView1.alpha = 0.5;
    lineView1.backgroundColor = [UIColor lightGrayColor];// COLOR_TEXT_LIGHYGARY;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _toolBarView.height -1, _toolBarView.width, 1)];
    lineView2.backgroundColor = [UIColor lightGrayColor];//COLOR_TEXT_LIGHYGARY;
    lineView2.alpha = 0.5;
    
    
    
    
    [_toolBarView addSubview:cancelBtn];
    [_toolBarView addSubview:submitBtn];
    [_toolBarView addSubview:lineView1];
    [_toolBarView addSubview:lineView2];
    
    
    [self addSubview:_datePicker];
    [self addSubview:_toolBarView];
    
    
    
    
}

#pragma mark - action

- (void)tooBarBtnClick:(UIButton *)sender
{

    
    BOOL isChange = (sender.tag == TooBarTag_Submit);
    
    if (self.dateChangeBlock) {
        
        [self.datePicker fintSubView:[UITableView class] action:^(NSArray *subViews) {
 
            for (UITableView *scView in subViews) {
                [scView setContentOffset:scView.contentOffset animated:YES];
            }
            
        }];
        
        
        dispatch_main_async_safe(^{
            self.dateChangeBlock(isChange,self.datePicker.date);
        });
        
        
    }
    
}



@end

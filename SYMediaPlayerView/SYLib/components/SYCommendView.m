//
//  SYCommendView.m
//  DGThumbUpButton
//
//  Created by 张双义 on 16/8/5.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "SYCommendView.h"
#import "UIView+SYExtend.h"

#define SpaceWidth  5
#define SpaceHeight 5

@interface SYCommendView()

@property (nonatomic, strong)UIView *iconView;
@property (nonatomic, strong)UILabel *numberLabel;
@property (nonatomic, assign, readwrite)SYCommendViewType viewType;

@property (nonatomic, assign)BOOL isSelected;

@end


@implementation SYCommendView


- (instancetype)initWithFrame:(CGRect)frame viewType:(SYCommendViewType)viewType
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.viewType = viewType;
        self.viewStyle = SYCommendViewStyleDefault;
        [self creatSubviews];
        
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tapGesture];
        
    }
    
    
    return self;
}

//- (void)addTarget:(id)target action:(SEL)action
//{
//    self.target = target;
//    self.action = action;
//}

- (void)setSelected:(BOOL)selected
{
    self.isSelected = selected;
}


- (void)setCommentNumber:(NSInteger)commentNumber
{
    if (self.commentNumber == commentNumber) {
        return;
    }
    
    _commentNumber = commentNumber;
    _numberLabel.text = [NSString stringWithFormat:@"%ld",commentNumber];
    
    CGFloat numberWidth = [_numberLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_numberLabel.font} context:nil].size.width;
    
    if (ceilf(numberWidth) != _numberLabel.width) {
        _numberLabel.frame = CGRectMake(_iconView.right + SpaceWidth, 0, ceilf(numberWidth), self.height);
        
        self.width = _numberLabel.right + 5;
    }
    
    

}




#pragma makr - pravite


- (void)creatSubviews
{
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:13];
    _numberLabel.textColor = [UIColor grayColor];
    
    [self addSubview:_numberLabel];
    
    switch (_viewType) {
        case SYCommendViewTypeImage: {
            _iconView = ({
                UIImageView *iconImage = [[UIImageView alloc] init];
                iconImage.image = [UIImage imageNamed:@"Like-PlaceHold"];
                iconImage.highlightedImage = [UIImage imageNamed:@"Like-Blue"];
                iconImage;
            });
            break;
        }
        case SYCommendViewTypeLabel: {
            _iconView = ({
                UILabel *iconLabel = [[UILabel alloc] init];
                iconLabel.font = [UIFont systemFontOfSize:14];
                iconLabel.text = @"赞";
                iconLabel.textColor = [UIColor grayColor];
                iconLabel;
            });
            break;
        }
    }
    
    [self addSubview:_iconView];
    
    [self layoutFrame];
    
}

- (void)layoutFrame
{
    CGFloat numberWidth = [_numberLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_numberLabel.font} context:nil].size.width;
    
    switch (self.viewType) {
        case SYCommendViewTypeImage: {
            _iconView.frame = CGRectMake(5, 5, self.height - 10, self.height - 10);
            break;
        }
        case SYCommendViewTypeLabel: {
            [_iconView sizeToFit];
            _iconView.center = CGPointMake(5+_iconView.width/2, self.height/2);
            break;
        }
    }

    _numberLabel.frame = CGRectMake(_iconView.right + SpaceWidth, 0, ceilf(numberWidth), self.height);
    
    self.width = _numberLabel.right + 5;
    
}



- (void)setIsSelected:(BOOL)isSelected
{
    if (_isSelected == isSelected) {
        return;
    }
    
    _isSelected = isSelected;
    
    
}



#pragma mark - action

- (void)tapClick
{
    self.isSelected = !self.isSelected;
    
    if (_isSelected) {
        [self popOutsideWithDuration:0.5];
    }else{
        [self popInsideWithDuration:0.5];
    }
    
    
    if (self.commentBlock) {
        self.commentBlock(self);
    }
    
}

- (void)doSelected
{
    switch (self.viewType) {
        case SYCommendViewTypeImage: {
            [(UIImageView *)self.iconView setImage:[UIImage imageNamed: @"Like-Blue"]];
            break;
        }
        case SYCommendViewTypeLabel: {
            [(UILabel *)self.iconView setTextColor:[UIColor orangeColor]];
            break;
        }
    }
    
    self.commentNumber += 1;
    
    
}

- (void)doUnSeleted
{
    switch (self.viewType) {
        case SYCommendViewTypeImage: {
            [(UIImageView *)self.iconView setImage:[UIImage imageNamed: @"Like-PlaceHold"]];
            break;
        }
        case SYCommendViewTypeLabel: {
            [(UILabel *)self.iconView setTextColor:[UIColor grayColor]];
            break;
        }
    }
    self.commentNumber -= 1;
}

- (void) popOutsideWithDuration: (NSTimeInterval) duringTime {

    self.transform = CGAffineTransformIdentity;
    
    UIView *actionView = self.iconView;
    
    [UIView animateKeyframesWithDuration: duringTime delay: 0 options: 0 animations: ^{
        
        [self doSelected];
    
        [UIView addKeyframeWithRelativeStartTime: 0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          actionView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 1 / 3.0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          actionView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 2 / 3.0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          actionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      }];
    } completion: ^(BOOL finished) {
        if (!self.isSelected) {
            [self doUnSeleted];
        }
    }];
}

- (void) popInsideWithDuration: (NSTimeInterval) duringTime {

    self.transform = CGAffineTransformIdentity;
    
    UIView *actionView = self.iconView;
    
    [UIView animateKeyframesWithDuration: duringTime delay: 0 options: 0 animations: ^{
        [self doUnSeleted];
        [UIView addKeyframeWithRelativeStartTime: 0
                                relativeDuration: 1 / 2.0
                                      animations: ^{
                                          actionView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 1 / 2.0
                                relativeDuration: 1 / 2.0
                                      animations: ^{
                                          actionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      }];
    } completion: ^(BOOL finished) {
        if (self.isSelected) {
            [self doSelected];
        }
    }];
    
}

















@end

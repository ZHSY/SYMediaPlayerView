//
//  SYChateTable.m
//  XzyPatient
//
//  Created by 张双义 on 16/7/18.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SYChateTable.h"

@interface SYChateTable()


@property (nonatomic, assign)BOOL naturalUpdate;


@end

@implementation SYChateTable

/**
 *  继承 beginUpdates 方法 避免Update 时的动画占用
 */
- (void)beginUpdates
{
    [super beginUpdates];
    self.naturalUpdate = YES;
}



- (void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(self.contentSize, CGSizeZero))
    {
        if (self.naturalUpdate) {//避免收发消息时的动画占用情况
            self.naturalUpdate = NO;
        }
        else
        if (contentSize.height > self.contentSize.height)
        {
            CGPoint offset = self.contentOffset;
            offset.y += (contentSize.height - self.contentSize.height);
            self.contentOffset = offset;
        }
    }
    [super setContentSize:contentSize];
}




@end

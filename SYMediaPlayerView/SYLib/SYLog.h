//
//  SYLog.h
//  XzyPatient
//
//  Created by 张双义 on 16/7/22.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

//模拟器
#if TARGET_IPHONE_SIMULATOR//模拟器
#define SYLogRunEnv NO
#elif TARGET_OS_IPHONE//真机
#define SYLogRunEnv YES
#endif

#define SYLogAble NO

#define SYPrintLog(...) {NSString *info = [NSString stringWithFormat:__VA_ARGS__];[SYLog logToFile:info];}


static const BOOL SYLogWrite = (SYLogRunEnv && SYLogAble);

@interface SYLog : NSObject


+ (void)logToFile:(NSString *)info;

/**
 *  目前读取全是失败。无法直接从app写到Mac桌面
 */
+ (void)readLogToPath:(NSString *)filePath;


/**
 *  打印内容 同步
 */
+ (void)logContent:(NSString *)content;



@end

//
//  Tool_ZSY.h
//  XzyDoctor
//
//  Created by 张双义 on 15/11/25.
//  Copyright © 2015年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+SYBaseMethod.h"


#pragma mark - 消息提示
#import "SYPrompt.h"


#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#pragma mark - Block -

/**
 *  回调无参数
 */
typedef void(^BackRefreshBlock)(void);

/**
 *  回调有一个参数
 */
typedef void(^BackRefreshParamBlock)(id param);

/**
 *  回调有一个BOOL参数
 */
typedef void(^BackRefreshSuccessBlock)(BOOL isSuccess);


@interface Tool_ZSY : NSObject


#pragma mark - 时间相关

#pragma mark －－ 日期和时间 相互格式化

/**
 *  日期转时间 转出格式：2015-11-19 19:05:11
 */
+(NSString *)strDateFrameDate_ss:(NSDate *)date;

/**
 *  日期转时间 转出格式：2015-11-19
 */
+(NSString *)strDateFrameDate_dd:(NSDate *)date;

/**
 *  日期转时间 转出格式：2015年11月19日
 */
+(NSString *)strCNDateFrameDate:(NSDate *)date;


//str转date 传入格式：2015-11-19 19:05:11
+(NSDate *)dateFromeStr_ss:(NSString *)strDate;

//str转date 传入格式：2015-11-19
+(NSDate *)dateFromeStr_dd:(NSString *)strDate;

/**
 *  str转date ---- 传入格式：2015年11月19日 ---- NSDate
 */
+(NSDate *)dateFromeStrCN_dd:(NSString *)strDate;

//str转时间戳 传入格式：2015-11-19 19:05:11
+(NSTimeInterval)strDateToTimeInterval_ss:(NSString *)strDate;

/**
 *   转换日期 到整天 ---- 传入格式：2015-11-19 19:05:11 ---- return 2015-11-19
 */
+(NSString *)strDateToDayDate_ss:(NSString *)strDate;

/**
 *   转换日期 到整天 ---- 传入格式：2015-11-19 19:05:11/2015-11-19 ---- return 2015年11月19日
 */
+(NSString *)strDateToDayDateCN:(NSString *)strDate;

/**
 *   转换日期 到整天 ---- 传入格式：2015年11月19日 ---- return 2015-11-19
 */
+(NSString *)strDateFrameCNDate:(NSString *)strDate;




#pragma mark - 计算时间差
/**
 *  计算时间差 ---- 精确到1分钟 ----- 传入格式：2015-11-19 19:05:11
 */
+(NSString *)getDatePassByStrDate_ss:(NSString *)strDate;

/**
 *  计算时间差 ---- 精确到1天 ---- 传入格式：2015-11-19
 */
+(NSString *)getDatePassByStrDate_dd:(NSString *)strDate;


//出生Date 计算年龄 @张双义
+(NSInteger)ageByBirthDay:(NSDate *)birthDay;



#pragma mark - 颜色相关

#define SRGBColor(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

//创建颜色
+ (UIColor *) colorWithHexString: (NSString *)color;



#pragma mark 无数据提示
//需要占用 superView 子view 的tag
+ (void)showNoDataView:(UIView *)superView message:(NSString *)msg tag:(NSInteger)tag;
+ (void)hidNoDataView:(UIView *)superView tag:(NSInteger)tag;



#pragma mark - 属性字符串处理

//设置行间距字符串
+ (NSAttributedString *)makeString:(NSString *)strText widthRowSpac:(CGFloat)rowSpace;
+ (NSAttributedString *)makeString:(NSString *)strText widthRowSpac:(CGFloat)rowSpace attributes:(NSDictionary *)attributes;


#pragma mark 字符串－XX 转换

/**
 *  数字转汉字(只支持阿拉伯数字和单位)
 *
 *  @param number 数字／数值
 *
 *  @return 汉字数字或单位
 */
+(NSString *)numberToChinese:(int)number;


#pragma mark 图片相关

/**
 *  通过颜色来生成一个纯色图片
 */
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

/**
 *  通过颜色来生成一个纯色图片
 */
+ (UIImage *)imageFromImage:(UIImage *)image color:(UIColor *)color;




@end

//
//#pragma mark - 网络请求相关
//
//#import "AFNetworking.h"
//@interface SY_AFNetworking : NSObject
///**
// *  封装的网络请求
// *
// *  @param URLString  url
// *  @param parameters 参数
// *  @param success    请求成功调用的block
// *  @param failure    请求失败调用的block
// *
// *  @注意 弱引用避免循环引用（应该不需要）
// */
//+(void)POST:(NSString *)URLString
// parameters:(id)parameters
//    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
//    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
///**
// *  封装的网络请求
// *
// *  @param URLString  url
// *  @param parameters 参数
// *  @param block      组织参数的block
// *  @param success    请求成功调用的block
// *  @param failure    请求失败调用的block
// *
// *  @注意 弱引用避免循环引用（应该不需要）
// */
//+ (void)POST:(NSString *)URLString
//  parameters:(id)parameters
//constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
//     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
//     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
//@end







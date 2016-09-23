//
//  NSObject+SYBaseMethod.h
//  XzyDoctor
//
//  Created by 张双义 on 16/4/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SYBaseMethod)

/**
 *  获取所有属性列表
 *  通过运行时获取当前对象的所有属性的名称，以数组的形式返回
 */
- (NSArray *)allPropertyNames;

/**
 *  转换成对应类别 相同字段直接赋值， 不同字段直接忽略
 */
- (id)tranfToClass:(Class)newClass;

///**
// *  转换成字典
// */
//- (NSDictionary *)tranfToDictionary;

/**
 *  创建模型 并根据字典设置属性
 */
+ (instancetype)creatFromDictionary:(NSDictionary *)dictModel;


/**
 *  返回 属性详请
 */
- (NSString *)detailDescription;


@end

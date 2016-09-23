//
//  NSObject+SYBaseMethod.m
//  XzyDoctor
//
//  Created by 张双义 on 16/4/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "NSObject+SYBaseMethod.h"

#import <objc/runtime.h>

@implementation NSObject (SYBaseMethod)


//通过运行时获取当前对象的所有属性的名称，以数组的形式返回
- (NSArray *) allPropertyNames{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}

- (id)tranfToClass:(Class)newClass
{
    NSArray *allKeys = [self allPropertyNames];
    
    NSObject *newObjc = [[newClass alloc] init];

    @try {
        for (NSString *key in allKeys) {
            [newObjc setValue:[self valueForKey:key] forKey:key];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"类别转换：%@ ---> %@ 出错 ,error:%@",  NSStringFromClass([self class]),NSStringFromClass([newClass class]),exception);
    }

    return newObjc;
    
}


/**
 *  创建模型 并根据字典设置属性
 */
+ (instancetype)creatFromDictionary:(NSDictionary *)dictModel
{
    id objc = [[self alloc] init];
    
    [objc setValuesForKeysWithDictionary:dictModel];
    
    return objc;
}


/**
 *  返回 属性详请
 */
- (NSString *)detailDescription
{
    NSArray *keys = [self allPropertyNames];
    
    NSMutableString *desc = [[NSMutableString alloc] init];
    
    for (NSString *key in keys) {
        [desc appendString:[NSString stringWithFormat:@"\n%@:%@",key,[self valueForKey:key]]];
    }
    
    return desc;
    
}





@end

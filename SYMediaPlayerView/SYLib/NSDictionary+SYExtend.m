//
//  NSDictionary+SYExtend.m
//  XzyPatient
//
//  Created by 张双义 on 16/7/4.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "NSDictionary+SYExtend.h"
#import "NSObject+SYBaseMethod.h"

#define HOST_PROJECT_PATH @"/Users/zhangshuangyi/Desktop/Project/Patient/XzyPatient"


@implementation NSDictionary (SYExtend)

- (void)propertyCode
{
    NSMutableString *logStr = [[NSMutableString alloc] init];
    for (NSString *key in self.allKeys) {
        
        
        Class valueClass = [[self valueForKey:key] class];
        [valueClass superclass];

        [logStr appendFormat: @"@property (nonatomic, strong)%@\t*%@;\t././%@\n",[self checkPrintClassName:valueClass], key,[self valueForKey:key]];
        
    }
    
    NSLog(@"\n%@\n",logStr);
    
    
}

- (void)propertyCodeToModelClass:(Class)modelClass
{
    NSMutableString *newAttributes = [[NSMutableString alloc] init];
    
    NSArray *allCreatedKeys = [[[modelClass alloc] init] allPropertyNames];
    
    NSArray *allKeys = self.allKeys;
    
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSBackwardsSearch];
    }];
    
    for (NSString *key in allKeys) {
        
        
        if ([allCreatedKeys indexOfObject:key] != NSNotFound) {
            continue;
        }
        
        Class valueClass = [[self valueForKey:key] class];
        [valueClass superclass];
        
        
        
        [newAttributes appendFormat: @"@property (nonatomic, strong)%@\t*%@;\t/* %@ */\n",[self checkPrintClassName:valueClass], key,[self valueForKey:key]];
        
    }
    
    if (newAttributes.length>0) {
        BOOL result = [self updateProjectModleFile:modelClass appentContent:newAttributes];
        if (result) {
            NSLog(@"新属性写入成功");
        }else{
            NSLog(@"新属性写入失败");
        }
    }
}


/**
 *  根据提供的class 库 审查给定的class 的baseClass
 *  return baseClassName
 */
- (NSString *)checkPrintClassName:(Class)class
{
    NSArray *classes = @[
                       [NSDictionary class],
                       [NSString class],
                       [NSArray class],
                       [NSNumber class],
                       [NSData class],
                       [NSValue class]
                       ];

    Class currentClass;
    for (Class baseClass in classes) {
        if ([class isSubclassOfClass:baseClass]) {
            currentClass = baseClass;
            break;
        }
    }
    
    if (currentClass) {
        return NSStringFromClass(currentClass);
    }else{
        return NSStringFromClass(class);
    }
    
    
}


/**
 *  根据 传入的 class 更新 本地对应文件的属性内容
 */
- (BOOL)updateProjectModleFile:(Class)class appentContent:(NSString *)appentContent
{
    NSString *modelName = [NSString stringWithFormat:@"%@.h",NSStringFromClass(class)];
    
    
    NSString *filePath;
    
    
    BOOL isDict;
    if (![[NSFileManager defaultManager] fileExistsAtPath:HOST_PROJECT_PATH isDirectory:&isDict]) {
        NSLog(@"文件路径错误,错误的文件目录/文件名");
        return NO;
    }else if (!isDict) {
        filePath = HOST_PROJECT_PATH;
    }else{
        filePath = [self findFilePath:modelName basePath:HOST_PROJECT_PATH];
    }
    
    if (!filePath) {
        NSLog(@"文件路径错误,未找到指定文件");
        return NO;
    }else{
        
        //-------------------- 写文件 -----------------------

        //打开文件，生成文件句柄
        NSFileHandle * fileHandel = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        
        //获取文件内容
        NSData *oladData = [fileHandel readDataToEndOfFile];
        NSString *oldContent = [[NSString alloc] initWithData:oladData encoding:NSUTF8StringEncoding];
        
        //找到 @end 语句 默认第一个 @end 语句之前为 该model 的类
        NSRange range  = [oldContent rangeOfString:@"@end"];
        
       
        //组织新的 data内容
        NSString *replaceContent = [appentContent stringByAppendingString:@"\n\n@end"];
        NSString *newContent = [oldContent stringByReplacingCharactersInRange:range withString:replaceContent];
        NSData *newData = [newContent dataUsingEncoding:NSUTF8StringEncoding];

        //每次写入数据会继续上次的写的内容 每次打开文件都会从头开始写
        
        //未避免不是从头写所以先 清空源文件数据
        [fileHandel truncateFileAtOffset:0];
        
        //定位到结尾（其实没必要，因为已经清空了文件内容）
        [fileHandel seekToEndOfFile];
        
        //写入新数据
        [fileHandel writeData:newData];

        [fileHandel closeFile];
        
        return YES;
    }
    
    
}

- (NSString *)findFilePath:(NSString *)fileName basePath:(NSString *)basePath
{
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取当前目录下的所有文件
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:basePath error:nil];
    
    for (NSString *itemFile in directoryContents) {
        NSString *tempPath = [basePath stringByAppendingFormat:@"/%@",itemFile];
        
        BOOL isDict;
        [fileManager fileExistsAtPath:tempPath isDirectory:&isDict];
        
        if (!isDict) {
            if ([itemFile isEqualToString:fileName]) {
                return tempPath;
            }
        }else{
            NSString *filePath = [self findFilePath:fileName basePath:tempPath];
            if (filePath) {
                return filePath;
            }
        }
        
    }
    
    return nil;


    
    
}



@end

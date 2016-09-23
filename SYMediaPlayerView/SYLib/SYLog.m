//
//  SYLog.m
//  XzyPatient
//
//  Created by 张双义 on 16/7/22.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SYLog.h"


#define OneMinuteTime 60
#define OneHourTime (OneMinuteTime*60)
#define OneDayTime (OneHourTime*24)

#define NumBer_ReadDay 7

@interface SYLog()

@property (nonatomic, strong)NSMutableArray     *catchMessages;
@property (nonatomic, strong)NSDateFormatter    *dateFormatter;
@property (nonatomic, strong)NSLock             *theadLock;

@end

@implementation SYLog

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _catchMessages = [[NSMutableArray alloc] init];
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.fffffff"];
        
        _theadLock = [[NSLock alloc] init];
    }
    
    
    return self;
    
}

+ (instancetype)defaultLogObject
{
    static SYLog *logObject;
    if (!logObject) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            logObject = [[SYLog alloc] init];
        });
    }
    
    return logObject;
}



+ (void)logToFile:(NSString *)info
{
    
    SYLog *logObject = [SYLog defaultLogObject];
    
    [logObject logToFile:info];
    
    
    
}


+ (void)logContent:(NSString *)content
{
    SYLog *logObject = [SYLog defaultLogObject];
    
    NSString *time = [logObject.dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *messageObject = @{@"time":time,@"info":content};
    
    [logObject logMessage:messageObject];
    
    
}


- (void)logToFile:(NSString *)info
{
    NSString *time = [self.dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *messageObject = @{@"time":time,@"info":info};
    
    NSThread *newThead = [[NSThread alloc] initWithTarget:self selector:@selector(logMessage:) object:messageObject];
    
    [newThead start];
    
    
}

- (void)logMessage:(NSDictionary *)messageObject
{
    if (!SYLogWrite) {
        return;
    }
    [_theadLock lock];
    
    //数据
    NSString *message = [NSString stringWithFormat:@"%@: \t%@\n",messageObject[@"time"],messageObject[@"info"]];
    NSData *logData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //路径
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *fileName = [@"xzyLog" stringByAppendingString:[[self.dateFormatter stringFromDate:[NSDate date]] substringToIndex:10]];
    
    NSString* logPath = [[basePath stringByAppendingPathComponent:fileName]stringByAppendingPathExtension:@"txt"];
    
    
    NSFileManager* fm=[NSFileManager defaultManager];
    
    BOOL isDict;
    if (![fm fileExistsAtPath:logPath isDirectory:&isDict]) {
        printf("未找到日志文件，创建日志文件\n");
        BOOL success1=[fm createFileAtPath:logPath contents:logData attributes:nil];
        if(success1){
            NSString *str = [NSString stringWithFormat:@"日志文件创建并写入成功,路径：%@",logPath];
            const char * a =[str UTF8String];

            printf("%s\n", a);
        }else{
            printf("日志文件首次创建失败\n");

        }
        
    }else{
        
        //-------------------- 写文件 -----------------------
        
        //打开文件，生成文件句柄
        NSFileHandle * fileHandel = [NSFileHandle fileHandleForUpdatingAtPath:logPath];
        
        //定位到结尾（其实没必要，因为已经清空了文件内容）
        [fileHandel seekToEndOfFile];
        
        //写入新数据
        [fileHandel writeData:logData];
        
        [fileHandel closeFile];
        
    }

    
    
    
    
    
    [_theadLock unlock];
    
}


+ (void)readLogToPath:(NSString *)filePath
{
    
    SYLog *logObject = [SYLog defaultLogObject];
    
    NSThread *newThead = [[NSThread alloc] initWithTarget:logObject selector:@selector(readLogToPath:) object:filePath];
    
    [newThead start];
}


- (void)readLogToPath:(NSString *)filePath
{
    //路径
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
 
    float time = 0;
    for (int i= 0 ; i<NumBer_ReadDay; i++) {
        
        NSDate *date= [NSDate dateWithTimeIntervalSinceNow:-time];
        
        NSString *fileName = [@"xzyLog" stringByAppendingString:[[self.dateFormatter stringFromDate:date] substringToIndex:10]];
        NSString* logPath = [[basePath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"txt"];
        NSString *newFilePath = [[filePath stringByAppendingString:fileName] stringByAppendingPathExtension:@"txt"];
        [self readLogFile:logPath toFile:newFilePath];
        
        time += OneDayTime;
        
    }

    
}

- (void)readLogFile:(NSString *)logPath toFile:(NSString *)filePath
{
    
    NSFileManager* fm=[NSFileManager defaultManager];
    
    
    BOOL isDict;
    if (![fm fileExistsAtPath:logPath isDirectory:&isDict]) {
        const char * sss =[logPath UTF8String];
        printf("日志读取失败，未找到日志文件,%s\n",sss);
        return;
    }
    
    //打开文件，生成文件句柄
    NSFileHandle * logFileHandel = [NSFileHandle fileHandleForUpdatingAtPath:logPath];
    //获取日志数据
    NSData *logData = [logFileHandel readDataToEndOfFile];
    
    
    
    int index = 1;
    
    NSString *newPath = filePath;
    while ([fm fileExistsAtPath:newPath isDirectory:&isDict]) {
        index++;
        
        newPath = [NSString stringWithFormat:@"%@%d",filePath,index];
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString* thepath = [paths lastObject];
    printf("桌面目录：%s", [thepath UTF8String]);
    
    BOOL success1=[fm createFileAtPath:newPath contents:logData attributes:nil];

    const char * charPath =[filePath UTF8String];
    if(success1){
        printf("日志文件创建并写入成功,路径%s\n", charPath);
    }else{
        printf("新的日志文件创建失败:%s\n",charPath);
        
    }
    
    [logFileHandel closeFile];
    
    
}






@end

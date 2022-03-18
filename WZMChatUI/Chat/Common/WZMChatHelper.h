//
//  WZMChatHelper.h
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMChatHelper : NSObject

+ (instancetype)helper;

///聊天气泡
+ (UIImage *)senderBubble;
+ (UIImage *)receiverBubble;
///获取当前时间戳
+ (NSTimeInterval)nowTimestamp;
///获取指定时间戳
+ (NSTimeInterval)timestampFromDate:(NSDate *)date;
///获取指定日期
+ (NSDate *)dateFromTimeStamp:(NSString *)timeStamp;
///时间格式化
+ (NSString *)timeFromTimeStamp:(NSString *)timeStamp;
+ (NSString *)timeFromDate:(NSDate *)date;

#pragma mark - 图片缓存处理
///最大缓存,单位M,默认50
@property (nonatomic, assign) NSInteger maxCacheSize;
///加载网络图片(同步)
- (UIImage *)getImageWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch;
///加载网络图片(异步)
- (UIImage *)getImageWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch completion:(void(^)(UIImage *image))completion;

///加载网络数据(同步)
- (NSData *)getDataWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch;
///加载网络数据(异步)
- (NSData *)getDataWithUrl:(NSString *)url isUseCatch:(BOOL)isUseCatch completion:(void(^)(NSData *data))completion;

///存储图片到本地,不会存入缓存
- (NSString *)setObj:(id)obj forKey:(NSString *)key;
- (NSData *)objForKey:(NSString *)key;

///文件路径
- (NSString *)filePathForKey:(NSString *)key;
///清理内存
- (void)clearMemory;
///清理所有数据
- (void)clearImageCacheCompletion:(void(^)(void))completion;

@end

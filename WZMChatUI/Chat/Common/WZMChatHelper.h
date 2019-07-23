//
//  WZMChatHelper.h
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMChatHelper : NSObject

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
///加载网络图片(同步)
+ (UIImage *)getImageWithUrl:(NSString *)url;
///加载网络图片(异步)
+ (void)getImageWithUrl:(NSString *)url placeholder:(UIImage *)placeholder completion:(void(^)(UIImage *image))completion;
///存图片
+ (NSString *)storeImage:(UIImage *)image forKey:(NSString *)key;
///取图片
+ (UIImage *)imageForKey:(NSString *)key;
///清理内存
+ (void)clearMemory;
///清理所有数据
+ (void)clearImageCacheCompletion:(void(^)(void))completion;

@end

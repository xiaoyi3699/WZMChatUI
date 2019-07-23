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

@end

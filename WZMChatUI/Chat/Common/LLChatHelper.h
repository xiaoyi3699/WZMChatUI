//
//  LLChatHelper.h
//  LLChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLChatHelper : NSObject

+ (instancetype)shareInstance;

///是否是iPhoneX
- (BOOL)iPhoneX;
///导航高
- (CGFloat)navBarH;
///taBar高
- (CGFloat)tabBarH;
///屏幕宽
- (CGFloat)screenW;
///屏幕高
- (CGFloat)screenH;
///输入框高度
- (CGFloat)inputH;
///键盘高度
- (CGFloat)keyboardH;
///输入框和键盘的高度和
- (CGFloat)inputKeyboardH;
///iPhoneX底部高度
- (CGFloat)iPhoneXBottomH;

//聊天气泡
- (UIImage *)senderBubbleImage;
- (UIImage *)receiverBubbleImage;

//获取当前时间戳
+ (NSTimeInterval)nowTimestamp;

//获取指定时间戳
+ (NSTimeInterval)timestampFromDate:(NSDate *)date;

//获取指定日期
+ (NSDate *)dateFromTimeStamp:(NSString *)timeStamp;

//时间格式化
+ (NSString *)timeFromTimeStamp:(NSString *)timeStamp;
+ (NSString *)timeFromDate:(NSDate *)date;

//图片
+ (UIImage *)otherImageNamed:(NSString *)name;
+ (UIImage *)emoticonImageNamed:(NSString *)name;

@end

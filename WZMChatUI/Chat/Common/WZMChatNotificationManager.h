//
//  WZMChatNotificationManager.h
//  LLChat
//
//  Created by WangZhaomeng on 2019/4/30.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZMChatNotificationManager : NSObject

///发送刷新session的通知
+ (void)postSessionNotification;
///监听刷新session的通知
+ (void)observerSessionNotification:(id)instant sel:(SEL)sel;
///移除通知
+ (void)removeObserver:(id)instant;

@end

//
//  WZMChatMessageManager.h
//  WZMChat
//
//  Created by WangZhaomeng on 2019/4/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//  消息管理

#import <UIKit/UIKit.h>
#import "WZMChatMessageModel.h"
#import "WZMChatUserModel.h"

@interface WZMChatMessageManager : NSObject

#pragma mark - 创建消息模型
//创建系统消息
+ (WZMChatMessageModel *)createSystemMessage:(WZMChatUserModel *)userModel
                                    message:(NSString *)message
                                   isSender:(BOOL)isSender;

///创建文本消息
+ (WZMChatMessageModel *)createTextMessage:(WZMChatUserModel *)userModel
                                  message:(NSString *)message
                                 isSender:(BOOL)isSender;

///创建录音消息
+ (WZMChatMessageModel *)createVoiceMessage:(WZMChatUserModel *)userModel
                                  duration:(NSInteger)duration
                                  voiceUrl:(NSString *)voiceUrl
                                  isSender:(BOOL)isSender;

///创建图片消息
+ (WZMChatMessageModel *)createImageMessage:(WZMChatUserModel *)userModel
                                 thumbnail:(NSString *)thumbnail
                                  original:(NSString *)original
                                 thumImage:(UIImage *)thumImage
                                  oriImage:(UIImage *)oriImage
                                  isSender:(BOOL)isSender;

///创建视频消息
+ (WZMChatMessageModel *)createVideoMessage:(WZMChatUserModel *)userModel
                                  videoUrl:(NSString *)videoUrl
                                  coverUrl:(NSString *)coverUrl
                                coverImage:(UIImage *)coverImage
                                  isSender:(BOOL)isSender;

@end

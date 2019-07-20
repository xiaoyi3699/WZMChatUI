//
//  LLChatMessageManager.h
//  LLChat
//
//  Created by WangZhaomeng on 2019/4/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//  消息管理

#import <UIKit/UIKit.h>
#import "LLChatMessageModel.h"
#import "LLChatUserModel.h"

@interface LLChatMessageManager : NSObject

#pragma mark - 创建消息模型
//创建系统消息
+ (LLChatMessageModel *)createSystemMessage:(LLChatUserModel *)userModel
                                    message:(NSString *)message
                                   isSender:(BOOL)isSender;

///创建文本消息
+ (LLChatMessageModel *)createTextMessage:(LLChatUserModel *)userModel
                                  message:(NSString *)message
                                 isSender:(BOOL)isSender;

///创建录音消息
+ (LLChatMessageModel *)createVoiceMessage:(LLChatUserModel *)userModel
                                  duration:(NSInteger)duration
                                  voiceUrl:(NSString *)voiceUrl
                                  isSender:(BOOL)isSender;

///创建图片消息
+ (LLChatMessageModel *)createImageMessage:(LLChatUserModel *)userModel
                                 thumbnail:(NSString *)thumbnail
                                  original:(NSString *)original
                                 thumImage:(UIImage *)thumImage
                                  oriImage:(UIImage *)oriImage
                                  isSender:(BOOL)isSender;

///创建视频消息
+ (LLChatMessageModel *)createVideoMessage:(LLChatUserModel *)userModel
                                  videoUrl:(NSString *)videoUrl
                                  coverUrl:(NSString *)coverUrl
                                coverImage:(UIImage *)coverImage
                                  isSender:(BOOL)isSender;

@end

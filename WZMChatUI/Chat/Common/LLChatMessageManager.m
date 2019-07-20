//
//  LLChatMessageManager.m
//  LLChat
//
//  Created by WangZhaomeng on 2019/4/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "LLChatMessageManager.h"
#import "WZMImageCache.h"
#import "LLChatUserModel.h"
#import "LLChatHelper.h"

@implementation LLChatMessageManager

#pragma mark - 创建消息模型
//创建系统消息
+ (LLChatMessageModel *)createSystemMessage:(LLChatUserModel *)userModel
                                    message:(NSString *)message
                                   isSender:(BOOL)isSender {
    LLChatMessageModel *msgModel = [[LLChatMessageModel alloc] init];
    msgModel.msgType = LLMessageTypeSystem;
    msgModel.message = message;
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

//创建文本消息
+ (LLChatMessageModel *)createTextMessage:(LLChatUserModel *)userModel
                                  message:(NSString *)message
                                 isSender:(BOOL)isSender {
    LLChatMessageModel *msgModel = [[LLChatMessageModel alloc] init];
    msgModel.msgType = LLMessageTypeText;
    msgModel.message = message;
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

//创建录音消息
+ (LLChatMessageModel *)createVoiceMessage:(LLChatUserModel *)userModel
                                  duration:(NSInteger)duration
                                  voiceUrl:(NSString *)voiceUrl
                                  isSender:(BOOL)isSender {
    LLChatMessageModel *msgModel = [[LLChatMessageModel alloc] init];
    msgModel.msgType = LLMessageTypeVoice;
    msgModel.message = @"[语音]";
    msgModel.duration = duration;
    msgModel.voiceUrl = voiceUrl;
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

//创建图片消息
+ (LLChatMessageModel *)createImageMessage:(LLChatUserModel *)userModel
                                 thumbnail:(NSString *)thumbnail
                                  original:(NSString *)original
                                 thumImage:(UIImage *)thumImage
                                  oriImage:(UIImage *)oriImage
                                  isSender:(BOOL)isSender {
    LLChatMessageModel *msgModel = [[LLChatMessageModel alloc] init];
    msgModel.msgType   = LLMessageTypeImage;
    msgModel.message   = @"[图片]";
    msgModel.thumbnail = thumbnail;
    msgModel.original  = original;
    msgModel.imgW = oriImage.size.width;
    msgModel.imgH = oriImage.size.height;
    //将图片保存到本地
    [[WZMImageCache imageCache] storeImage:oriImage forKey:original];
    [[WZMImageCache imageCache] storeImage:thumImage forKey:thumbnail];
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

//创建视频消息
+ (LLChatMessageModel *)createVideoMessage:(LLChatUserModel *)userModel
                                  videoUrl:(NSString *)videoUrl
                                  coverUrl:(NSString *)coverUrl
                                coverImage:(UIImage *)coverImage
                                  isSender:(BOOL)isSender {
    LLChatMessageModel *msgModel = [[LLChatMessageModel alloc] init];
    msgModel.msgType   = LLMessageTypeVideo;
    msgModel.message   = @"[视频]";
    msgModel.videoUrl = videoUrl;
    msgModel.coverUrl  = coverUrl;
    msgModel.imgW = coverImage.size.width;
    msgModel.imgH = coverImage.size.height;
    //将封面图片保存到本地
    [[WZMImageCache imageCache] storeImage:coverImage forKey:coverUrl];
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

#pragma mark - pravite
+ (void)setConfig:(LLChatMessageModel *)msgModel userModel:(LLChatUserModel *)userModel isSender:(BOOL)isSender {
    if (isSender) {
        msgModel.uid    = [LLChatUserModel shareInfo].uid;
        msgModel.name   = [LLChatUserModel shareInfo].name;
        msgModel.avatar = [LLChatUserModel shareInfo].avatar;
    }
    else {
        msgModel.uid    = userModel.uid;
        msgModel.name   = userModel.name;
        msgModel.avatar = userModel.avatar;
    }
    msgModel.sender  = isSender;
    msgModel.sendType  = LLMessageSendTypeWaiting;
    msgModel.timestmp  = [LLChatHelper nowTimestamp];
}

@end

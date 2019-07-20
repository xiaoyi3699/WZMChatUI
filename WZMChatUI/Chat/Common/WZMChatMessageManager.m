//
//  WZMChatMessageManager.m
//  WZMChat
//
//  Created by WangZhaomeng on 2019/4/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMChatMessageManager.h"
#import "WZMImageCache.h"
#import "WZMChatUserModel.h"
#import "WZMChatHelper.h"

@implementation WZMChatMessageManager

#pragma mark - 创建消息模型
//创建系统消息
+ (WZMChatMessageModel *)createSystemMessage:(WZMChatUserModel *)userModel
                                    message:(NSString *)message
                                   isSender:(BOOL)isSender {
    WZMChatMessageModel *msgModel = [[WZMChatMessageModel alloc] init];
    msgModel.msgType = WZMMessageTypeSystem;
    msgModel.message = message;
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

//创建文本消息
+ (WZMChatMessageModel *)createTextMessage:(WZMChatUserModel *)userModel
                                  message:(NSString *)message
                                 isSender:(BOOL)isSender {
    WZMChatMessageModel *msgModel = [[WZMChatMessageModel alloc] init];
    msgModel.msgType = WZMMessageTypeText;
    msgModel.message = message;
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

//创建录音消息
+ (WZMChatMessageModel *)createVoiceMessage:(WZMChatUserModel *)userModel
                                  duration:(NSInteger)duration
                                  voiceUrl:(NSString *)voiceUrl
                                  isSender:(BOOL)isSender {
    WZMChatMessageModel *msgModel = [[WZMChatMessageModel alloc] init];
    msgModel.msgType = WZMMessageTypeVoice;
    msgModel.message = @"[语音]";
    msgModel.duration = duration;
    msgModel.voiceUrl = voiceUrl;
    [self setConfig:msgModel userModel:userModel isSender:isSender];
    return msgModel;
}

//创建图片消息
+ (WZMChatMessageModel *)createImageMessage:(WZMChatUserModel *)userModel
                                 thumbnail:(NSString *)thumbnail
                                  original:(NSString *)original
                                 thumImage:(UIImage *)thumImage
                                  oriImage:(UIImage *)oriImage
                                  isSender:(BOOL)isSender {
    WZMChatMessageModel *msgModel = [[WZMChatMessageModel alloc] init];
    msgModel.msgType   = WZMMessageTypeImage;
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
+ (WZMChatMessageModel *)createVideoMessage:(WZMChatUserModel *)userModel
                                  videoUrl:(NSString *)videoUrl
                                  coverUrl:(NSString *)coverUrl
                                coverImage:(UIImage *)coverImage
                                  isSender:(BOOL)isSender {
    WZMChatMessageModel *msgModel = [[WZMChatMessageModel alloc] init];
    msgModel.msgType   = WZMMessageTypeVideo;
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
+ (void)setConfig:(WZMChatMessageModel *)msgModel userModel:(WZMChatUserModel *)userModel isSender:(BOOL)isSender {
    if (isSender) {
        msgModel.uid    = [WZMChatUserModel shareInfo].uid;
        msgModel.name   = [WZMChatUserModel shareInfo].name;
        msgModel.avatar = [WZMChatUserModel shareInfo].avatar;
    }
    else {
        msgModel.uid    = userModel.uid;
        msgModel.name   = userModel.name;
        msgModel.avatar = userModel.avatar;
    }
    msgModel.sender  = isSender;
    msgModel.sendType  = WZMMessageSendTypeWaiting;
    msgModel.timestmp  = [WZMChatHelper nowTimestamp];
}

@end

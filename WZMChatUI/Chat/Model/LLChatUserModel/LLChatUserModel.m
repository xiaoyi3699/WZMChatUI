//
//  LLChatUserModel.m
//  LLChat
//
//  Created by WangZhaomeng on 2019/4/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "LLChatUserModel.h"

@implementation LLChatUserModel

///默认登录用户
+ (instancetype)shareInfo {
    static LLChatUserModel *userInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[LLChatUserModel alloc] init];
        userInfo.uid = @"00001";
        userInfo.name = @"无敌是多么的寂寞";
        userInfo.avatar = @"http://sqb.wowozhe.com/images/home/wx_appicon.png";
    });
    return userInfo;
}

@end

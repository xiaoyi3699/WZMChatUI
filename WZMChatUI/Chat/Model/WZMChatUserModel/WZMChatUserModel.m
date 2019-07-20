//
//  WZMChatUserModel.m
//  LLChat
//
//  Created by WangZhaomeng on 2019/4/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMChatUserModel.h"

@implementation WZMChatUserModel

///默认登录用户
+ (instancetype)shareInfo {
    static WZMChatUserModel *userInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[WZMChatUserModel alloc] init];
        userInfo.uid = @"00001";
        userInfo.name = @"无敌是多么的寂寞";
        userInfo.avatar = @"http://sqb.wowozhe.com/images/home/wx_appicon.png";
    });
    return userInfo;
}

@end

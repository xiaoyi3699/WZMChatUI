//
//  WZMChatViewController.h
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMChatUserModel.h"
#import "WZMChatGroupModel.h"
#import "WZMChatSessionModel.h"

@interface WZMChatViewController : UIViewController

///选择用户进入聊天
- (instancetype)initWithUser:(WZMChatUserModel *)userModel;

///选择群进入聊天
- (instancetype)initWithGroup:(WZMChatGroupModel *)groupModel;

///选择会话进入聊天
- (instancetype)initWithSession:(WZMChatSessionModel *)sessionModel;

@end

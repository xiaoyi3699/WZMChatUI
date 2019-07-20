//
//  WZChatMacro.h
//  WZMChat
//
//  Created by WangZhaomeng on 2019/7/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#ifndef WZChatMacro_h
#define WZChatMacro_h

#import "WZMChatHelper.h"
#define WZMChat_SCREEN_WIDTH   [[WZMChatHelper shareInstance] screenW]
#define WZMChat_SCREEN_HEIGHT  [[WZMChatHelper shareInstance] screenH]

#define WZMChat_IPHONEX    [[WZMChatHelper shareInstance] iPhoneX]
#define WZMChat_NAV_TOP_H  [[WZMChatHelper shareInstance] navBarH]
#define WZMChat_BAR_BOT_H  [[WZMChatHelper shareInstance] tabBarH]
#define WZMChat_BOTTOM_H   [[WZMChatHelper shareInstance] iPhoneXBottomH]

//输入框的高度
#define WZMChat_INPUT_H    [[WZMChatHelper shareInstance] inputH]
//自定义键盘的高度(不包含输入框)
#define WZMChat_KEYBOARD_H [[WZMChatHelper shareInstance] keyboardH]

//默认图
#define WZMChat_BAD_IMAGE [WZMChatHelper otherImageNamed:@"wzm_chat_default"]

#define R_G_B(_r_,_g_,_b_) [UIColor colorWithRed:_r_/255. green:_g_/255. blue:_b_/255. alpha:1.0]
#define R_G_B_A(_r_,_g_,_b_,_a_) [UIColor colorWithRed:_r_/255. green:_g_/255. blue:_b_/255. alpha:_a_]

#endif /* LLMacro_h */

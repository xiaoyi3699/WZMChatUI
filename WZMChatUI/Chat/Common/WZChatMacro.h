//
//  WZChatMacro.h
//  WZMChat
//
//  Created by WangZhaomeng on 2019/7/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#ifndef WZChatMacro_h
#define WZChatMacro_h

#import "WZMInputHelper.h"
#define CHAT_SCREEN_WIDTH  [[WZMInputHelper helper] screenW]
#define CHAT_SCREEN_HEIGHT [[WZMInputHelper helper] screenH]

#define CHAT_IPHONEX   [[WZMInputHelper helper] iPhoneX]
#define CHAT_NAV_BAR_H [[WZMInputHelper helper] navBarH]
#define CHAT_TAB_BAR_H [[WZMInputHelper helper] tabBarH]
#define CHAT_BOTTOM_H  [[WZMInputHelper helper] iPhoneXBottomH]

//默认图
#define CHAT_BAD_IMAGE [WZMInputHelper otherImageNamed:@"wzm_chat_default"]

#endif /* LLMacro_h */

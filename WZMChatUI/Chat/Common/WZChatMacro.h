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
#define WZMChat_SCREEN_WIDTH   [[WZMInputHelper helper] screenW]
#define WZMChat_SCREEN_HEIGHT  [[WZMInputHelper helper] screenH]

#define WZMChat_IPHONEX    [[WZMInputHelper helper] iPhoneX]
#define WZMChat_NAV_TOP_H  [[WZMInputHelper helper] navBarH]
#define WZMChat_BAR_BOT_H  [[WZMInputHelper helper] tabBarH]
#define WZMChat_BOTTOM_H   [[WZMInputHelper helper] iPhoneXBottomH]

//默认图
#define WZMChat_BAD_IMAGE [WZMInputHelper otherImageNamed:@"wzm_chat_default"]

#endif /* LLMacro_h */

//
//  WZMChatBtn.h
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WZMChatButtonTypeNormal = 0,   //系统默认类型
    WZMChatButtonTypeRetry,        //重发消息按钮
    WZMChatButtonTypeInput,        //键盘工具按钮
    WZMChatButtonTypeMoreKeyboard, //加号键盘按钮
}WZMChatButtonType;

@interface WZMChatBtn : UIButton

+ (instancetype)chatButtonWithType:(WZMChatButtonType)type;

@end

//
//  WZMChatBtn.m
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMChatBtn.h"

@interface WZMChatBtn ()

@property (nonatomic, assign) WZMChatButtonType type;

@end

@implementation WZMChatBtn

+ (instancetype)chatButtonWithType:(WZMChatButtonType)type{
    WZMChatBtn *baseBtn = [super buttonWithType:UIButtonTypeCustom];
    if (baseBtn) {
        baseBtn.type = type;
    }
    return baseBtn;
}

//重设image的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    if (self.currentImage) {
        if (_type == WZMChatButtonTypeRetry) {
            //实际应用中要根据情况，返回所需的frame
            return CGRectMake(12.5, 12.5, 15, 15);
        }
    }
    return [super imageRectForContentRect:contentRect];
}

@end

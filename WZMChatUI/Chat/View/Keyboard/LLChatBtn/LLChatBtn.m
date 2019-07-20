//
//  LLChatBtn.m
//  LLChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLChatBtn.h"

@interface LLChatBtn ()

@property (nonatomic, assign) LLChatButtonType type;

@end

@implementation LLChatBtn

+ (instancetype)chatButtonWithType:(LLChatButtonType)type{
    LLChatBtn *baseBtn = [super buttonWithType:UIButtonTypeCustom];
    if (baseBtn) {
        baseBtn.type = type;
    }
    return baseBtn;
}

//重设image的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    if (self.currentImage) {
        if (_type == LLChatButtonTypeRetry) {
            //实际应用中要根据情况，返回所需的frame
            return CGRectMake(12.5, 12.5, 15, 15);
        }
        if (_type == LLChatButtonTypeInput) {
            //实际应用中要根据情况，返回所需的frame
            return CGRectMake(5, 5, 30, 30);
        }
        if (_type == LLChatButtonTypeMoreKeyboard) {
            //实际应用中要根据情况，返回所需的frame
            return CGRectMake(10, 15, 40, 40);
        }
    }
    return [super imageRectForContentRect:contentRect];
}

//重设title的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (_type == LLChatButtonTypeMoreKeyboard) {
        //实际应用中要根据情况，返回所需的frame
        return CGRectMake(0, 55, 60, 25);
    }
    return [super titleRectForContentRect:contentRect];
}

@end

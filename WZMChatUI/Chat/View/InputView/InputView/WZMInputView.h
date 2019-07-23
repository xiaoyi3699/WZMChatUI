//
//  WZMInputView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/19.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMBaseInputView.h"
#import "WZNInputEnum.h"
@protocol WZMInputViewDelegate;

@interface WZMInputView : WZMBaseInputView

@property (nonatomic, weak) id<WZMInputViewDelegate> delegate;

@end

@protocol WZMInputViewDelegate <NSObject>

@optional
///文本变化
- (void)inputView:(WZMInputView *)inputView didChangeText:(NSString *)text;
///发送文本消息
- (void)inputView:(WZMInputView *)inputView sendMessage:(NSString *)message;
///自定义键盘点击事件
- (void)inputView:(WZMInputView *)inputView didSelectMoreType:(WZInputMoreType)type;
///录音状态变化
- (void)inputView:(WZMInputView *)inputView didChangeRecordType:(WZMRecordType)type;
///输入框frame改变
- (void)inputView:(WZMInputView *)inputView willChangeFrameWithDuration:(CGFloat)duration;

@end

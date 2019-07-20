//
//  WZMInputView.h
//  LLChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEmojisKeyboard.h"
#import "WZMChatMoreKeyboard.h"

@protocol WZMInputViewDelegate;

typedef enum : NSInteger {
    LLChatRecordTypeTouchDown = 0,
    LLChatRecordTypeTouchCancel,
    LLChatRecordTypeTouchFinish,
    LLChatRecordTypeTouchDragInside,
    LLChatRecordTypeTouchDragOutside,
}LLChatRecordType;

@interface WZMInputView : UIView

@property (nonatomic, weak) id<WZMInputViewDelegate> delegate;

- (void)chatBecomeFirstResponder;
- (void)chatResignFirstResponder;
- (void)setText:(NSString *)text;

@end

@protocol WZMInputViewDelegate <NSObject>

@optional
///文本变化
- (void)inputView:(WZMInputView *)inputView didChangeText:(NSString *)text;
///发送文本消息
- (void)inputView:(WZMInputView *)inputView sendMessage:(NSString *)message;
///自定义键盘点击事件
- (void)inputView:(WZMInputView *)inputView selectedType:(WZMChatMoreType)type;
///录音状态变化
- (void)inputView:(WZMInputView *)inputView didChangeRecordType:(LLChatRecordType)type;
///输入框frame改变
- (void)inputView:(WZMInputView *)inputView willChangeFrameWithDuration:(CGFloat)duration isEditing:(BOOL)isEditing;

@end

//
//  LLInputView.h
//  LLChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLEmojisKeyboard.h"
#import "LLChatMoreKeyboard.h"

@protocol LLInputViewDelegate;

typedef enum : NSInteger {
    LLChatRecordTypeTouchDown = 0,
    LLChatRecordTypeTouchCancel,
    LLChatRecordTypeTouchFinish,
    LLChatRecordTypeTouchDragInside,
    LLChatRecordTypeTouchDragOutside,
}LLChatRecordType;

@interface LLInputView : UIView

@property (nonatomic, weak) id<LLInputViewDelegate> delegate;

- (void)chatBecomeFirstResponder;
- (void)chatResignFirstResponder;
- (void)setText:(NSString *)text;

@end

@protocol LLInputViewDelegate <NSObject>

@optional
///文本变化
- (void)inputView:(LLInputView *)inputView didChangeText:(NSString *)text;
///发送文本消息
- (void)inputView:(LLInputView *)inputView sendMessage:(NSString *)message;
///自定义键盘点击事件
- (void)inputView:(LLInputView *)inputView selectedType:(LLChatMoreType)type;
///录音状态变化
- (void)inputView:(LLInputView *)inputView didChangeRecordType:(LLChatRecordType)type;
///输入框frame改变
- (void)inputView:(LLInputView *)inputView willChangeFrameWithDuration:(CGFloat)duration isEditing:(BOOL)isEditing;

@end

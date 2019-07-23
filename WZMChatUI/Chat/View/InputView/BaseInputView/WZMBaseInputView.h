//
//  WZMBaseInputView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/19.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZNInputEnum.h"

@interface WZMBaseInputView : UIView

///文本
@property (nonatomic, strong) NSString *text;
///toolView的高度
@property (nonatomic, assign, readonly) CGFloat toolViewH;
///当前键盘的高度
@property (nonatomic, assign, readonly) CGFloat keyboardH;
///当前键盘类型
@property (nonatomic, assign, readonly) WZMKeyboardType type;
///是否处于编辑状态, 自定义键盘模式为非编辑状态
@property (nonatomic, assign, readonly, getter=isEditing) BOOL editing;

///创建视图
- (void)createViews NS_REQUIRES_SUPER;

#pragma mark - 公开的方法
//使用时只需要调用这两个方法即可
- (void)becomeFirstResponder;
- (void)resignFirstResponder;

#pragma mark - 内部以及子类内部调用的方法
///显示系统键盘
- (void)showSystemKeyboard;
///显示自定义键盘
- (void)showKeyboardAtIndex:(NSInteger)index duration:(CGFloat)duration;
///结束编辑
- (void)dismissKeyboard;
///输入框字符串处理
- (void)deleteSelectedText;
- (void)replaceSelectedTextWithText:(NSString *)text;

#pragma mark - 子类中回调的方法
///开始编辑, 是否是系统键盘
- (void)didBeginEditing;
///结束编辑
- (void)didEndEditing;
///输入框值改变
- (void)valueDidChange;

///是否允许开始编辑
- (BOOL)shouldBeginEditing;
///是否允许结束编辑
- (BOOL)shouldEndEditing;
///是否允许点击return键
- (BOOL)shouldReturn;
///是否允许编辑
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

///还原视图
- (void)willResetConfig;
///视图frame改变
- (void)willChangeFrameWithDuration:(CGFloat)duration;

#pragma mark - 子类中需要实现的数据源
///自定义toolView和keyboards
- (UIView *)toolViewOfInputView;
- (NSArray<UIView *> *)keyboardsOfInputView;
///视图的初始y值
- (CGFloat)startYOfInputView;

@end

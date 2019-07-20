//
//  WZMInputView.m
//  LLChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMInputView.h"
#import "WZChatMacro.h"
#import "UIView+WZMChat.h"
#import "WZMEmoticonManager.h"

typedef enum : NSInteger {
    WZMInputViewTypeNone = 0,
    WZMInputViewTypeKeyboard,
    WZMInputViewTypeVoice,
    WZMInputViewTypeEmotion,
    WZMInputViewTypeMore,
}WZMInputType;
@interface WZMInputView ()<UITextViewDelegate,WZMEmojisKeyboardDelegate,WZMChatMoreKeyboardDelegate>

@property (nonatomic, strong) WZMChatMoreKeyboard *moreKeyboard;
@property (nonatomic, strong) WZMEmojisKeyboard *emojisKeyboard;
@property (nonatomic, assign) WZMInputType type;

@end

@implementation WZMInputView {
    WZMChatBtn *_voiceBtn;
    WZMChatBtn *_emotionBtn;
    WZMChatBtn *_moreBtn;
    UITextView *_textView;
    UIButton *_recordBtn;
    BOOL _isEditing;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, LLCHAT_SCREEN_HEIGHT-LLCHAT_INPUT_H-LLCHAT_BOTTOM_H, LLCHAT_SCREEN_WIDTH, [[WZMChatHelper shareInstance] inputKeyboardH]+150)];
    if (self) {
        self.type = WZMInputViewTypeNone;
        
        CGFloat w = self.LLWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        [self addSubview:lineView];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
        NSArray *images = @[@"wzm_chat_voice",@"wzm_chat_emotion",@"wzm_chat_more"];
        UIImage *keyboardImg = [WZMChatHelper otherImageNamed:@"wzm_chat_board"];
        for (NSInteger i = 0; i < 3; i ++) {
            WZMChatBtn *btn = [WZMChatBtn chatButtonWithType:WZMChatButtonTypeInput];
            
            if (i == 0) {
                btn.frame = CGRectMake(0, 4.5, 40, 40);
                _voiceBtn = btn;
            }
            else if (i == 1) {
                btn.frame = CGRectMake(w-80, 4.5, 40, 40);
                _emotionBtn = btn;
            }
            else {
                btn.frame = CGRectMake(w-40, 4.5, 40, 40);
                _moreBtn = btn;
            }
            
            btn.tag = i;
            [btn setImage:[WZMChatHelper otherImageNamed:images[i]] forState:UIControlStateNormal];
            [btn setImage:keyboardImg forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            [array addObject:btn];
        }
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(40, 7, w-120, 35)];
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.textColor = [UIColor darkTextColor];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.delegate = self;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 2;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1].CGColor;
        [self addSubview:_textView];
        
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.frame = _textView.frame;
        _recordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _recordBtn.backgroundColor = [UIColor whiteColor];
        _recordBtn.layer.masksToBounds = YES;
        _recordBtn.layer.cornerRadius = 2;
        _recordBtn.layer.borderWidth = 0.5;
        _recordBtn.layer.borderColor = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1].CGColor;
        [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchCancel];
        [_recordBtn addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchUpOutside];
        [_recordBtn addTarget:self action:@selector(touchFinish:) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
        [_recordBtn addTarget:self action:@selector(touchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [self addSubview:_recordBtn];
        _recordBtn.hidden = YES;
        
        [self addSubview:self.moreKeyboard];
        [self addSubview:self.emojisKeyboard];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardValueChange:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - 监听键盘变化
- (void)keyboardValueChange:(NSNotification *)notification {
    if (_textView.isFirstResponder == NO) return;
    NSDictionary *dic = notification.userInfo;
    CGFloat duration = [dic[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect endFrame = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if (endFrame.origin.y == LLCHAT_SCREEN_HEIGHT) {
        //键盘收回
        if (_isEditing) {
            //弹出自定义键盘
            CGFloat minY = LLCHAT_SCREEN_HEIGHT-[[WZMChatHelper shareInstance] inputKeyboardH];
            [self minYWillChange:minY duration:duration isFinishEditing:NO];
        }
    }
    else {
        //键盘谈起
        CGFloat minY = endFrame.origin.y-LLCHAT_INPUT_H;
        [self minYWillChange:minY duration:duration isFinishEditing:NO];
    }
}

- (void)minYWillChange:(CGFloat)minY duration:(CGFloat)duration isFinishEditing:(BOOL)isFinishEditing {
    _isEditing = !isFinishEditing;
    if (isFinishEditing) {
        minY -= LLCHAT_BOTTOM_H;
        [self recoverSetting:_voiceBtn.selected];
    }
    else {
        if (_moreBtn.selected) {
            //点击了更多按钮
            self.emojisKeyboard.hidden = YES;
            self.moreKeyboard.hidden = NO;
        }
        else if (_emotionBtn.selected) {
            //点击了表情按钮
            self.emojisKeyboard.hidden = NO;
            self.moreKeyboard.hidden = YES;
        }
    }
    CGRect endFrame = self.frame;
    endFrame.origin.y = minY;
    [UIView animateWithDuration:duration animations:^{
        self.frame = endFrame;
    }];
    if ([self.delegate respondsToSelector:@selector(inputView:willChangeFrameWithDuration:isEditing:)]) {
        [self.delegate inputView:self willChangeFrameWithDuration:duration isEditing:_isEditing];
    }
}

#pragma mark - 用户交互事件
- (void)btnClick:(UIButton *)btn {
    if (btn.isSelected) {
        _recordBtn.hidden = YES;
        [self chatBecomeFirstResponder];
    }
    else {
        btn.selected = YES;
        if (btn.tag == 0) {
            //声音按钮
            _moreBtn.selected = NO;
            _emotionBtn.selected = NO;
            _recordBtn.hidden = NO;
            //结束编辑
            [self chatResignFirstResponder];
        }
        else {
            _recordBtn.hidden = YES;
            if (btn.tag == 1) {
                //表情按钮
                _voiceBtn.selected = NO;
                _moreBtn.selected = NO;
            }
            else {
                //加号按钮
                _voiceBtn.selected = NO;
                _emotionBtn.selected = NO;
            }
            
            if (_textView.isFirstResponder) {
                [_textView resignFirstResponder];
            }
            else {
                //弹出自定义键盘
                CGFloat duration = 0.25;
                CGFloat minY = LLCHAT_SCREEN_HEIGHT-[[WZMChatHelper shareInstance] inputKeyboardH];
                [self minYWillChange:minY duration:duration isFinishEditing:NO];
            }
        }
    }
}

#pragma mark - 录音状态变化
- (void)touchDown:(UIButton *)btn {
    [_recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self didChangeRecordType:LLChatRecordTypeTouchDown];
}

- (void)touchCancel:(UIButton *)btn {
    [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self didChangeRecordType:LLChatRecordTypeTouchCancel];
}

- (void)touchFinish:(UIButton *)btn {
    [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self didChangeRecordType:LLChatRecordTypeTouchFinish];
}

- (void)touchDragOutside:(UIButton *)btn {
    [_recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self didChangeRecordType:LLChatRecordTypeTouchDragOutside];
}

- (void)touchDragInside:(UIButton *)btn {
    [_recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self didChangeRecordType:LLChatRecordTypeTouchDragInside];
}

- (void)didChangeRecordType:(LLChatRecordType)type {
    if ([self.delegate respondsToSelector:@selector(inputView:didChangeRecordType:)]) {
        [self.delegate inputView:self didChangeRecordType:type];
    }
}

#pragma mark - public method
- (void)chatBecomeFirstResponder {
    if (_isEditing == NO) {
        _isEditing = YES;
    }
    [_textView becomeFirstResponder];
}

- (void)chatResignFirstResponder {
    if (_isEditing) {
        _isEditing = NO;
        //结束编辑
        CGFloat duration = 0.25;
        CGFloat minY = LLCHAT_SCREEN_HEIGHT-LLCHAT_INPUT_H;
        [self minYWillChange:minY duration:duration isFinishEditing:YES];
    }
    [_textView resignFirstResponder];
}

- (void)setText:(NSString *)text {
    _textView.text = text;
}

#pragma mark - private method
- (void)sendMessage {
    if (_textView.text.length > 0) {
        if ([self.delegate respondsToSelector:@selector(inputView:sendMessage:)]) {
            [self.delegate inputView:self sendMessage:_textView.text];
        }
        _textView.text = @"";
    }
}

//还原按钮状态
- (void)recoverSetting:(BOOL)isClickVoice {
    if (!isClickVoice) {
        _voiceBtn.selected = NO;
    }
    
    _emotionBtn.selected = NO;
    _moreBtn.selected = NO;
    
    self.emojisKeyboard.hidden = YES;
    self.moreKeyboard.hidden = YES;
}

#pragma mark - delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        [self emojisKeyboardDelete];
        return NO;
    }
    if ([text isEqualToString:@"\n"] ||
        [text isEqualToString:@"\n\n"] ||
        [text isEqualToString:@"\r"] ||
        [text isEqualToString:@"\r\r"]) {
        
        [self sendMessage];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self recoverSetting:NO];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self didChangeText:textView.text];
}

- (void)didChangeText:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(inputView:didChangeText:)]) {
        [self.delegate inputView:self didChangeText:text];
    }
}

#pragma mark - emojisKeyboardDelegate;
//发送按钮
- (void)emojisKeyboardSend {
    [self sendMessage];
}

//删除按钮
- (void)emojisKeyboardDelete {
    if (_textView.text.length > 0) {
        NSRange range = _textView.selectedRange;
        NSUInteger location = range.location;
        NSUInteger length = range.length;
        if (location == 0 && length == 0) return;
        if (length > 0) {
            [_textView deleteBackward];
        }
        else {
            NSString *subString = [_textView.text substringToIndex:location];
            NSString *emoticon = [[WZMEmoticonManager manager] willDeleteEmoticon:subString];
            if ([[WZMEmoticonManager manager].chs containsObject:emoticon]) {
                NSUInteger newLocation = location-emoticon.length;
                _textView.text = [_textView.text stringByReplacingCharactersInRange:NSMakeRange(newLocation, emoticon.length) withString:@""];
                _textView.selectedRange = NSMakeRange(newLocation, 0);
            }
            else {
                [_textView deleteBackward];
            }
        }
    }
}

//输入文本
- (void)emojisKeyboardSendText:(NSString *)text {
    [_textView replaceRange:_textView.selectedTextRange withText:text];
    [self didChangeText:_textView.text];
}

- (void)moreKeyboardSelectedType:(WZMChatMoreType)type {
    if ([self.delegate respondsToSelector:@selector(inputView:selectedType:)]) {
        [self.delegate inputView:self selectedType:type];
    }
}

#pragma mark - getter
- (WZMEmojisKeyboard *)emojisKeyboard {
    if (_emojisKeyboard == nil) {
        _emojisKeyboard = [[WZMEmojisKeyboard alloc] initWithFrame:CGRectMake(0, LLCHAT_INPUT_H, LLCHAT_SCREEN_WIDTH, LLCHAT_KEYBOARD_H)];
        _emojisKeyboard.delegate = self;
        _emojisKeyboard.hidden = YES;
    }
    return _emojisKeyboard;
}

- (WZMChatMoreKeyboard *)moreKeyboard {
    if (_moreKeyboard == nil) {
        _moreKeyboard = [[WZMChatMoreKeyboard alloc] initWithFrame:CGRectMake(0, LLCHAT_INPUT_H, LLCHAT_SCREEN_WIDTH, LLCHAT_KEYBOARD_H)];
        _moreKeyboard.delegate = self;
        _moreKeyboard.hidden = YES;
    }
    return _moreKeyboard;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

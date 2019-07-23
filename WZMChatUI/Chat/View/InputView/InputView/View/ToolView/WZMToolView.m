//
//  WZMToolView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/22.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMToolView.h"
#import "WZMInputBtn.h"
#import "WZMInputHelper.h"
#import "WZMRecordAnimation.h"

@interface WZMToolView ()

@property (nonatomic, strong) WZMRecordAnimation *recordAnimation;

@end

@implementation WZMToolView {
    NSArray *_toolBtns;
    UIButton *_recordBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat toolW = self.bounds.size.width;
        CGFloat toolH = self.bounds.size.height;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, toolW, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1.0];
        [self addSubview:lineView];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(40, 7, toolW-120, 35)];
        textView.font = [UIFont systemFontOfSize:13];
        textView.textColor = [UIColor darkTextColor];
        textView.returnKeyType = UIReturnKeySend;
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = 2;
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1].CGColor;
        [self addSubview:textView];
        
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.frame = textView.frame;
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
        _recordBtn.hidden = YES;
        [self addSubview:_recordBtn];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
        NSArray *images = @[@"wzm_chat_voice",@"wzm_chat_emotion",@"wzm_chat_more"];//ll_chat_board
        UIImage *keyboardImg = [WZMInputHelper otherImageNamed:@"wzm_chat_board"];
        for (NSInteger i = 0; i < 3; i ++) {
            WZMInputBtn *btn = [WZMInputBtn chatButtonWithType:WZMInputBtnTypeTool];
            if (i == 0) {
                btn.frame = CGRectMake(0, 5, 40, 40);
            }
            else if (i == 1) {
                btn.frame = CGRectMake(toolW-80, 5, 40, 40);
            }
            else {
                btn.frame = CGRectMake(toolW-40, 5, 40, 40);
            }
            btn.tag = i;
            [btn setImage:[WZMInputHelper otherImageNamed:images[i]] forState:UIControlStateNormal];
            [btn setImage:keyboardImg forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [array addObject:btn];
        }
        _toolBtns = [array copy];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    WZMKeyboardType type;
    if (btn.tag == 0) {
        //语音按钮
        if (btn.isSelected) {
            _recordBtn.hidden = YES;
            type = WZMKeyboardTypeSystem;
        }
        else {
            _recordBtn.hidden = NO;
            type = WZMKeyboardTypeIdle;
        }
    }
    else if (btn.tag == 1) {
        //表情按钮
        _recordBtn.hidden = YES;
        if (btn.isSelected) {
            type = WZMKeyboardTypeSystem;
        }
        else {
            type = WZMKeyboardTypeEmoticon;
        }
    }
    else {
        //更多按钮
        _recordBtn.hidden = YES;
        if (btn.isSelected) {
            type = WZMKeyboardTypeSystem;
        }
        else {
            type = WZMKeyboardTypeMore;
        }
    }
    //设置btn状态
    for (UIButton *button in _toolBtns) {
        if (button.tag == btn.tag) {
            button.selected = !button.isSelected;
        }
        else {
            button.selected = NO;
        }
    }
    //调用代理
    if ([self.delegate respondsToSelector:@selector(toolView:didSelectAtIndex:)]) {
        [self.delegate toolView:self didSelectAtIndex:btn.tag];
    }
    if ([self.delegate respondsToSelector:@selector(toolView:showKeyboardType:)]) {
        [self.delegate toolView:self showKeyboardType:type];
    }
}

- (void)resetStatus {
    _recordBtn.hidden = YES;
    for (UIButton *button in _toolBtns) {
        button.selected = NO;
    }
}

#pragma mark - 录音状态变化
- (void)touchDown:(UIButton *)btn {
    [_recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self didChangeRecordType:UIControlEventTouchDown];
    //开始录音
    [self.recordAnimation beginRecord];
}

- (void)touchCancel:(UIButton *)btn {
    [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self didChangeRecordType:UIControlEventTouchCancel];
    //取消录音
    [self.recordAnimation cancelRecord];
}

- (void)touchFinish:(UIButton *)btn {
    [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    if ([self.recordAnimation endRecord]) {
        //结束录音
        [self didChangeRecordType:UIControlEventTouchUpInside];
    }
    else {
        //录音时长小于1秒, 取消录音
        [self didChangeRecordType:UIControlEventTouchCancel];
    }
}

- (void)touchDragOutside:(UIButton *)btn {
    [_recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.recordAnimation showVoiceCancel];
}

- (void)touchDragInside:(UIButton *)btn {
    [_recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.recordAnimation showVoiceAnimation];
}

- (void)didChangeRecordType:(UIControlEvents)touchEvent {
    WZMRecordType type;
    if (touchEvent == UIControlEventTouchDown) {
        type = WZMRecordTypeBegin;
    }
    else if (touchEvent == UIControlEventTouchUpInside) {
        type = WZMRecordTypeFinish;
    }
    else {
        type = WZMRecordTypeCancel;
    }
    if ([self.delegate respondsToSelector:@selector(toolView:didChangeRecordType:)]) {
        [self.delegate toolView:self didChangeRecordType:type];
    }
}

- (WZMRecordAnimation *)recordAnimation {
    if (_recordAnimation == nil) {
        _recordAnimation = [[WZMRecordAnimation alloc] init];
    }
    return _recordAnimation;
}

@end

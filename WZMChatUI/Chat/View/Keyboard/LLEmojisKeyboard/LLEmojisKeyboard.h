//
//  LLEmojisKeyboard.h
//  LLChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LLEmojisKeyboardDelegate;

@interface LLEmojisKeyboard : UIView

@property (nonatomic, weak) id<LLEmojisKeyboardDelegate> delegate;

@end

@protocol LLEmojisKeyboardDelegate <NSObject>

@optional
- (void)emojisKeyboardSend;
- (void)emojisKeyboardDelete;
- (void)emojisKeyboardSendText:(NSString *)text;

@end

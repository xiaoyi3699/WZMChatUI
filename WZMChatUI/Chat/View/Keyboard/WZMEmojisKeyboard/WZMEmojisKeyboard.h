//
//  WZMEmojisKeyboard.h
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMEmojisKeyboardDelegate;

@interface WZMEmojisKeyboard : UIView

@property (nonatomic, weak) id<WZMEmojisKeyboardDelegate> delegate;

@end

@protocol WZMEmojisKeyboardDelegate <NSObject>

@optional
- (void)emojisKeyboardSend;
- (void)emojisKeyboardDelete;
- (void)emojisKeyboardSendText:(NSString *)text;

@end

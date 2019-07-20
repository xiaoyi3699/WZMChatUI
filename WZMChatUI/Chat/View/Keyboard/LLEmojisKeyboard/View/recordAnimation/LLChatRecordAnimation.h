//
//  LLChatRecordAnimation.h
//  LLChat
//
//  Created by WangZhaomeng on 2019/5/23.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLChatRecordAnimation : UIImageView

///设置声音大小 (0 ~ 1)
@property (nonatomic, assign) CGFloat volume;

- (void)showVoiceCancel;
- (void)showVoiceShort;
- (void)showVoiceAnimation;

@end

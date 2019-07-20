//
//  LLChatMoreKeyboard.h
//  LLChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLChatBtn.h"

@protocol LLChatMoreKeyboardDelegate;

typedef enum : NSInteger {
    LLChatMoreTypeImage = 0,
    LLChatMoreTypeVideo,
    LLChatMoreTypeLocation,
    LLChatMoreTypeTransfer,
}LLChatMoreType;

@interface LLChatMoreKeyboard : UIView

@property (nonatomic, weak) id<LLChatMoreKeyboardDelegate> delegate;

@end

@protocol LLChatMoreKeyboardDelegate <NSObject>

@optional
- (void)moreKeyboardSelectedType:(LLChatMoreType)type;

@end

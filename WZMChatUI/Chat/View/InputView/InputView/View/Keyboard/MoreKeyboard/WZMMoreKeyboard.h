//
//  WZMMoreKeyboard.h
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZNInputEnum.h"
@protocol WZMMoreKeyboardDelegate;

@interface WZMMoreKeyboard : UIView

@property (nonatomic, weak) id<WZMMoreKeyboardDelegate> delegate;

@end

@protocol WZMMoreKeyboardDelegate <NSObject>

@optional
- (void)moreKeyboard:(WZMMoreKeyboard *)moreKeyboard didSelectType:(WZInputMoreType)type;

@end

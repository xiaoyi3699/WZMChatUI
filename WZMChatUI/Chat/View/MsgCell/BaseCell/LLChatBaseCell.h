//
//  LLChatBaseCell.h
//  LLChat
//
//  Created by WangZhaomeng on 2019/1/15.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLChatMessageModel.h"

@interface LLChatBaseCell : UITableViewCell

///系统消息 - 比如：时间消息等
- (void)setConfig:(LLChatMessageModel *)model;

///其他消息 - 比如：文本、图片消息等
- (void)setConfig:(LLChatMessageModel *)model isShowName:(BOOL)isShowName;

@end

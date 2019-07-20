//
//  WZMChatBaseCell.m
//  LLChat
//
//  Created by WangZhaomeng on 2019/1/15.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMChatBaseCell.h"

@implementation WZMChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setConfig:(WZMChatMessageModel *)model {}
- (void)setConfig:(WZMChatMessageModel *)model isShowName:(BOOL)isShowName {}

@end

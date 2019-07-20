//
//  LLChatBaseCell.m
//  LLChat
//
//  Created by WangZhaomeng on 2019/1/15.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "LLChatBaseCell.h"

@implementation LLChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setConfig:(LLChatMessageModel *)model {}
- (void)setConfig:(LLChatMessageModel *)model isShowName:(BOOL)isShowName {}

@end

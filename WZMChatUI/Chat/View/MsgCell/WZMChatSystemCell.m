//
//  WZMChatSystemCell.m
//  LLChat
//
//  Created by WangZhaomeng on 2019/1/15.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMChatSystemCell.h"
#import "WZChatMacro.h"

@implementation WZMChatSystemCell {
    UILabel *_messageLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LLCHAT_SCREEN_WIDTH, 20)];
        _messageLabel.font = [UIFont systemFontOfSize:10];
        _messageLabel.textColor = [UIColor colorWithRed:100/255. green:100/255. blue:100/255. alpha:1];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)setConfig:(WZMChatMessageModel *)model {
    _messageLabel.text = model.message;
}

@end

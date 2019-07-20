//
//  WZMChatVoiceMessageCell.m
//  LLChat
//
//  Created by WangZhaomeng on 2019/5/22.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMChatVoiceMessageCell.h"
#import "WZChatMacro.h"
#import "UIView+WZMChat.h"

@implementation WZMChatVoiceMessageCell {
    UILabel *_durationLabel;
    UIImageView *_voiceImageView;
    UIImageView *_unreadImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _voiceImageView = [[UIImageView alloc] init];
        [self addSubview:_voiceImageView];
        
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.textColor = [UIColor darkTextColor];
        _durationLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_durationLabel];
        
        _unreadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _unreadImageView.backgroundColor = R_G_B(250, 81, 81);
        [_unreadImageView setLLCornerRadius:4];
        [self addSubview:_unreadImageView];
    }
    return self;
}

- (void)setConfig:(WZMChatMessageModel *)model isShowName:(BOOL)isShowName {
    [super setConfig:model isShowName:isShowName];
    
    CGFloat x = _contentRect.origin.x, y = _contentRect.origin.y;
    CGFloat w = _contentRect.size.width, h = _contentRect.size.height;
    
    CGFloat imageW = 12, imageH = 15, imageY = y + (h-imageH)/2;
    if (model.isSender) {
        _voiceImageView.frame = CGRectMake(CGRectGetMaxX(_contentRect)-20-imageW, imageY, imageW, imageH);
        _voiceImageView.image = [WZMChatHelper otherImageNamed:@"wzm_chat_voice_2"];
        _durationLabel.frame = CGRectMake(x, y, w-_voiceImageView.LLWidth-25, h);
        _durationLabel.textAlignment = NSTextAlignmentRight;
        _unreadImageView.frame = CGRectMake(x-10, y, 8, 8);
        _unreadImageView.hidden = YES;
    }
    else {
        _voiceImageView.frame = CGRectMake(CGRectGetMinX(_contentRect)+20, imageY, imageW, imageH);
        _voiceImageView.image = [WZMChatHelper otherImageNamed:@"wzm_chat_voice_1"];
        _durationLabel.frame = CGRectMake(_voiceImageView.maxX+5, y, w-_voiceImageView.LLWidth-25, h);
        _durationLabel.textAlignment = NSTextAlignmentLeft;
        _unreadImageView.frame = CGRectMake(CGRectGetMaxX(_contentRect)+2, y, 8, 8);
        _unreadImageView.hidden = model.isRead;
    }
    _durationLabel.text = [NSString stringWithFormat:@"%@''",@(model.duration)];
}

@end

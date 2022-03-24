//
//  WZMSessionTableViewCell.m
//  WZMChat
//
//  Created by WangZhaomeng on 2019/4/30.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMSessionTableViewCell.h"

@implementation WZMSessionTableViewCell {
    UIImageView *_avatarImageView;
    UIView *_badgeView;
    UILabel *_badgeLabel;
    UILabel *_nameLabel;
    UILabel *_messageLabel;
    UILabel *_timeLabel;
    UIImageView *_notiImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 48, 48)];
        _avatarImageView.chat_cornerRadius = 5;
        [self.contentView addSubview:_avatarImageView];
        
        _badgeView = [[UIView alloc] initWithFrame:CGRectMake(_avatarImageView.chat_maxX-5, _avatarImageView.chat_minY-5, 10, 10)];
        _badgeView.backgroundColor = [UIColor colorWithRed:250/255. green:81/255. blue:81/255. alpha:1];
        _badgeView.chat_cornerRadius = 5;
        _badgeView.hidden = YES;
        [self.contentView addSubview:_badgeView];
        
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.chat_maxX-9, _avatarImageView.chat_minY-9, 18, 18)];
        _badgeLabel.font = [UIFont systemFontOfSize:12];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = [UIColor colorWithRed:250/255. green:81/255. blue:81/255. alpha:1];
        _badgeLabel.chat_cornerRadius = 9;
        _badgeLabel.hidden = YES;
        [self.contentView addSubview:_badgeLabel];
        
        CGFloat timeW = 100;
        CGFloat nickX = _avatarImageView.chat_maxX+15;
        CGFloat nimeW = CHAT_SCREEN_WIDTH-nickX-timeW-15;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickX, 13, nimeW, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor darkTextColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickX, _nameLabel.chat_maxY+7, nimeW+60, 15)];
        _messageLabel.font = [UIFont systemFontOfSize:13];
        _messageLabel.textColor = [UIColor colorWithRed:160/255. green:160/255. blue:160/255. alpha:1];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_messageLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.chat_maxX, 15, timeW, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        _notiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CHAT_SCREEN_WIDTH-32, _avatarImageView.chat_maxY-20, 17, 17)];
        _notiImageView.hidden = YES;
        _notiImageView.image = [WZMInputHelper otherImageNamed:@"wzm_chat_bell_not"];
        [self.contentView addSubview:_notiImageView];
    }
    return self;
}

- (void)setConfig:(WZMChatSessionModel *)model {
    
    BOOL isIgnore = model.isSilence;
    NSInteger lastTimestamp = model.lastTimestmp;
    NSString *unreadNum = model.unreadNum;
    NSString *lastMsg = model.lastMsg;
    
    if (isIgnore) {
        //消息免打扰
        _notiImageView.hidden = NO;
        _badgeLabel.text = @"";
        _badgeLabel.hidden = YES;
        if (unreadNum.integerValue > 0) {
            _badgeView.hidden = NO;
            if (unreadNum.integerValue > 1) {
                lastMsg = [NSString stringWithFormat:@"[%@条] %@",unreadNum,lastMsg];
            }
        }
        else {
            _badgeView.hidden = YES;
        }
    }
    else {
        //消息提醒
        _notiImageView.hidden = YES;
        if (unreadNum.integerValue <= 0) {
            _badgeLabel.text = @"";
            _badgeView.hidden = YES;
            _badgeLabel.hidden = YES;
        }
        else {
            if (unreadNum.integerValue < 10) {
                _badgeLabel.frame = CGRectMake(_avatarImageView.chat_maxX-9, _avatarImageView.chat_minY-9, 18, 18);
            }
            else if (unreadNum.integerValue < 100) {
                _badgeLabel.frame = CGRectMake(_avatarImageView.chat_maxX-17, _avatarImageView.chat_minY-9, 26, 18);
            }
            else {
                unreadNum = @"···";
                _badgeLabel.frame = CGRectMake(_avatarImageView.chat_maxX-21, _avatarImageView.chat_minY-9, 30, 18);
            }
            _badgeLabel.text = unreadNum;
            _badgeView.hidden = YES;
            _badgeLabel.hidden = NO;
        }
    }
    [[WZMChatHelper helper] getImageWithUrl:model.avatar isUseCatch:YES completion:^(UIImage *image) {
        _avatarImageView.image = image;
    }];
    _nameLabel.text = model.name;
    _messageLabel.text = lastMsg;
    _timeLabel.text = [WZMChatHelper timeFromTimeStamp:[NSString stringWithFormat:@"%@",@(lastTimestamp)]];
    
    if (_notiImageView.hidden) {
        _messageLabel.chat_width = _nameLabel.chat_width+100;
    }
    else {
        _messageLabel.chat_width = _nameLabel.chat_width+80;
    }
}

@end

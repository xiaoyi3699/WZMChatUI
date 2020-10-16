//
//  WZMUserTableViewCell.m
//  WZMChat
//
//  Created by WangZhaomeng on 2019/4/30.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMUserTableViewCell.h"
#import "UIView+WZMChat.h"
#import "WZChatMacro.h"

@implementation WZMUserTableViewCell {
    UIImageView *_avatarImageView;
    UILabel *_nameLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        _avatarImageView.chat_cornerRadius = 5;
        [self.contentView addSubview:_avatarImageView];
        
        CGFloat nickX = _avatarImageView.chat_maxX+15;
        CGFloat nickW = CHAT_SCREEN_WIDTH-nickX-20;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickX, 0, nickW, 60)];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor darkTextColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)setConfig:(WZMChatUserModel *)model {
    [WZMChatHelper getImageWithUrl:model.avatar placeholder:CHAT_BAD_IMAGE completion:^(UIImage *image) {
        _avatarImageView.image = image;
    }];
    _nameLabel.text = model.name;
}

@end

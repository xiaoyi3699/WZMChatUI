//
//  LLUserTableViewCell.m
//  LLChat
//
//  Created by WangZhaomeng on 2019/4/30.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "LLUserTableViewCell.h"
#import "WZMImageCache.h"
#import "UIView+WZMChat.h"
#import "WZChatMacro.h"

@implementation LLUserTableViewCell {
    UIImageView *_avatarImageView;
    UILabel *_nameLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        [_avatarImageView setLLCornerRadius:5];
        [self addSubview:_avatarImageView];
        
        CGFloat nickX = _avatarImageView.maxX+15;
        CGFloat nickW = LLCHAT_SCREEN_WIDTH-nickX-20;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickX, 0, nickW, 60)];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor darkTextColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)setConfig:(LLChatUserModel *)model {
    [[WZMImageCache imageCache] getImageWithUrl:model.avatar isUseCatch:YES placeholder:LLCHAT_BAD_IMAGE completion:^(UIImage *image) {
        _avatarImageView.image = image;
    }];
    _nameLabel.text = model.name;
}

@end

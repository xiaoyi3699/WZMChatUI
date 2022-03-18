//
//  WZMChatVideoMessageCell.m
//  WZMChat
//
//  Created by WangZhaomeng on 2019/5/22.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMChatVideoMessageCell.h"
#import "WZMChatHelper.h"
#import "WZChatMacro.h"

@implementation WZMChatVideoMessageCell {
    UIImageView *_markImageView;
    UIImageView *_contentImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.layer.masksToBounds = YES;
        _contentImageView.layer.cornerRadius = 5;
        [self.contentView addSubview:_contentImageView];
        
        _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _markImageView.image = [WZMInputHelper otherImageNamed:@"wzm_chat_video_mark"];
        [self.contentView addSubview:_markImageView];
    }
    return self;
}

- (void)setConfig:(WZMChatMessageModel *)model isShowName:(BOOL)isShowName {
    [super setConfig:model isShowName:isShowName];
    
    _contentImageView.frame = _contentRect;
    _markImageView.center = _contentImageView.center;
    [[WZMChatHelper helper] getImageWithUrl:model.coverUrl isUseCatch:YES completion:^(UIImage *image) {
        _contentImageView.image = image;
    }];
}

@end

//
//  LLChatImageMessageCell.m
//  LLChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLChatImageMessageCell.h"
#import "WZMImageCache.h"
#import "WZChatMacro.h"

@implementation LLChatImageMessageCell {
    UIImageView *_contentImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.layer.masksToBounds = YES;
        _contentImageView.layer.cornerRadius = 5;
        [self addSubview:_contentImageView];
    }
    return self;
}

- (void)setConfig:(LLChatMessageModel *)model isShowName:(BOOL)isShowName {
    [super setConfig:model isShowName:isShowName];
    
    _contentImageView.frame = _contentRect;
    
    [[WZMImageCache imageCache] getImageWithUrl:model.thumbnail isUseCatch:YES placeholder:LLCHAT_BAD_IMAGE completion:^(UIImage *image) {
        _contentImageView.image = image;
    }];
}

@end

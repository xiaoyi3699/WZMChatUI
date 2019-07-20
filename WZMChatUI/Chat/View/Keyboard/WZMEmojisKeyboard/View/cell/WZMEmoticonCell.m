//
//  WZMEmoticonCell.m
//  LLChat
//
//  Created by WangZhaomeng on 2019/5/16.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMEmoticonCell.h"
#import "WZMEmoticonManager.h"

@implementation WZMEmoticonCell {
    UIImageView *_emoticonImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _emoticonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 6, 35, 35)];
        [self addSubview:_emoticonImageView];
    }
    return self;
}

- (void)setConfig:(NSString *)image {
    _emoticonImageView.image = [[WZMEmoticonManager manager] emoticonWithImageName:image];
}

@end

//
//  WZMMoreKeyboard.m
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMMoreKeyboard.h"
#import "WZMInputBtn.h"
#import "WZMInputHelper.h"

@implementation WZMMoreKeyboard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSInteger count = 4;
        CGFloat itemW = 60;
        CGFloat itemH = 80;
        CGFloat left = 20;
        CGFloat spacing = (frame.size.width-itemW*count-left*2)/3;
        
        NSArray *images = @[@"wzm_chat_pic",@"wzm_chat_video",@"wzm_chat_locaion",@"wzm_chat_transfer"];
        NSArray *titles = @[@"图片",@"视频",@"待定",@"待定"];
        for (NSInteger i = 0; i < images.count; i ++) {
            WZMInputBtn *btn = [WZMInputBtn chatButtonWithType:WZMInputBtnTypeMore];
            btn.frame = CGRectMake(left+i%count*(itemW+spacing), i/count*itemH, itemW, itemH);
            btn.tag = i;
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setImage:[WZMInputHelper otherImageNamed:images[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    WZInputMoreType type = (WZInputMoreType)btn.tag;
    if ([self.delegate respondsToSelector:@selector(moreKeyboard:didSelectType:)]) {
        [self.delegate moreKeyboard:self didSelectType:type];
    }
}

@end

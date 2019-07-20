//
//  LLDeleteCell.m
//  LLChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLDeleteCell.h"
#import "LLChatHelper.h"

@implementation LLDeleteCell {
    UIImageView *_deleteImgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _deleteImgView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 40, 40)];
        _deleteImgView.image = [LLChatHelper otherImageNamed:@"ll_chat_delete"];
        [self addSubview:_deleteImgView];
    }
    return self;
}

@end

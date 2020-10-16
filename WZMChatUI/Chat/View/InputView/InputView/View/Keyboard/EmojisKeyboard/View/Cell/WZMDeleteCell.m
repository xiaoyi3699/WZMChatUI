//
//  WZMDeleteCell.m
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/5.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMDeleteCell.h"
#import "WZMInputHelper.h"

@implementation WZMDeleteCell {
    UIImageView *_deleteImgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _deleteImgView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 40, 40)];
        _deleteImgView.image = [WZMInputHelper otherImageNamed:@"wzm_chat_delete"];
        [self.contentView addSubview:_deleteImgView];
    }
    return self;
}

@end

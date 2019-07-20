//
//  WZMChatSessionModel.m
//  WZMChat
//
//  Created by WangZhaomeng on 2019/4/29.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMChatSessionModel.h"

@implementation WZMChatSessionModel

///时间戳排序
- (NSComparisonResult)compareOtherModel:(WZMChatSessionModel *)model {
    return self.lastTimestmp < model.lastTimestmp;
}

@end

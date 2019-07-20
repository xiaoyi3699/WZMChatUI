//
//  LLChatSessionModel.m
//  LLChat
//
//  Created by WangZhaomeng on 2019/4/29.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "LLChatSessionModel.h"

@implementation LLChatSessionModel

///时间戳排序
- (NSComparisonResult)compareOtherModel:(LLChatSessionModel *)model {
    return self.lastTimestmp < model.lastTimestmp;
}

@end

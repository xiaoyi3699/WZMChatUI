//
//  WZMChatSessionModel.h
//  WZMChat
//
//  Created by WangZhaomeng on 2019/4/29.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//  聊天会话

#import "WZMChatBaseModel.h"

@interface WZMChatSessionModel : WZMChatBaseModel

///会话id<若会话为群聊,则sid为群聊gid, 若会话为私聊,则sid为对方uid>
@property (nonatomic, strong) NSString *sid;
///昵称
@property (nonatomic, strong) NSString *name;
///头像
@property (nonatomic, strong) NSString *avatar;
///未读消息数
@property (nonatomic, strong) NSString *unreadNum;
///是否是群聊 <group为数据库关键字, 故使用该单词替代>
@property (nonatomic, assign, getter=isCluster) BOOL cluster;
///是否开启消息免打扰 <ignore为数据库关键字, 故使用该单词替代>
@property (nonatomic, assign, getter=isSilence) BOOL silence;
///最后一条消息
@property (nonatomic, strong) NSString *lastMsg;
///最后一条消息时间 <该字段参与数据排序, 不要修改字段名, 为了避开数据库关键字, 故意拼错>
@property (nonatomic, assign) NSInteger lastTimestmp;

///时间戳排序
- (NSComparisonResult)compareOtherModel:(WZMChatSessionModel *)model;

@end

//
//  WZMChatDBManager.h
//  WZMChat
//
//  Created by WangZhaomeng on 2019/4/29.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//  数据库操纵

#import <Foundation/Foundation.h>
#import "WZMChatBaseModel.h"
#import "WZMChatUserModel.h"
#import "WZMChatGroupModel.h"
#import "WZMChatSessionModel.h"
#import "WZMChatMessageModel.h"

@interface WZMChatDBManager : NSObject

///输入框草稿
@property (nonatomic, strong) NSMutableDictionary *draftDic;
///草稿
- (NSString *)draftWithModel:(WZMChatBaseModel *)model;
///删除草稿
- (void)removeDraftWithModel:(WZMChatBaseModel *)model;
///保存草稿
- (void)setDraft:(NSString *)draft model:(WZMChatBaseModel *)model;

+ (instancetype)DBManager;

#pragma mark - user表操纵
///所有用户
- (NSMutableArray *)users;
///添加用户
- (void)insertUserModel:(WZMChatUserModel *)model;
///更新用户
- (void)updateUserModel:(WZMChatUserModel *)model;
///查询用户
- (WZMChatUserModel *)selectUserModel:(NSString *)uid;
///删除用户
- (void)deleteUserModel:(NSString *)uid;

#pragma mark - group表操纵
///所有群
- (NSMutableArray *)groups;
///添加群
- (void)insertGroupModel:(WZMChatGroupModel *)model;
///更新群
- (void)updateGroupModel:(WZMChatGroupModel *)model;
///查询群
- (WZMChatGroupModel *)selectGroupModel:(NSString *)gid;
///删除群
- (void)deleteGroupModel:(NSString *)gid;

#pragma mark - session表操纵
///所有会话
- (NSMutableArray *)sessions;
///添加会话
- (void)insertSessionModel:(WZMChatSessionModel *)model;
///更新会话
- (void)updateSessionModel:(WZMChatSessionModel *)model;
///查询私聊会话
- (WZMChatSessionModel *)selectSessionModelWithUser:(WZMChatUserModel *)userModel;
///查询群聊会话
- (WZMChatSessionModel *)selectSessionModelWithGroup:(WZMChatGroupModel *)groupModel;
///删除会话
- (void)deleteSessionModel:(NSString *)sid;
///查询会话对应的用户或者群聊
- (WZMChatBaseModel *)selectChatModel:(WZMChatSessionModel *)model;
///查询会话对应的用户
- (WZMChatUserModel *)selectChatUserModel:(WZMChatSessionModel *)model;
///查询会话对应的群聊
- (WZMChatGroupModel *)selectChatGroupModel:(WZMChatSessionModel *)model;

#pragma mark - message表操纵
//私聊消息列表
- (NSMutableArray *)messagesWithUser:(WZMChatUserModel *)model;
//群聊消息列表
- (NSMutableArray *)messagesWithGroup:(WZMChatGroupModel *)model;
///插入私聊消息
- (void)insertMessage:(WZMChatMessageModel *)message chatWithUser:(WZMChatUserModel *)model;
///插入群聊消息
- (void)insertMessage:(WZMChatMessageModel *)message chatWithGroup:(WZMChatGroupModel *)model;
///更新私聊消息
- (void)updateMessageModel:(WZMChatMessageModel *)message chatWithUser:(WZMChatUserModel *)model;
///更新群聊消息
- (void)updateMessageModel:(WZMChatMessageModel *)message chatWithGroup:(WZMChatGroupModel *)model;

@end

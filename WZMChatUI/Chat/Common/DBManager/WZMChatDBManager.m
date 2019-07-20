//
//  WZMChatDBManager.m
//  WZMChat
//
//  Created by WangZhaomeng on 2019/4/29.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMChatDBManager.h"
#import "WZMChatSqliteManager.h"
#import "WZMChatMessageModel.h"

NSString *const LL_USER    = @"ll_user";
NSString *const LL_GROUP   = @"ll_group";
NSString *const LL_SESSION = @"ll_session";

@implementation WZMChatDBManager

+ (instancetype)DBManager {
    static WZMChatDBManager *DBManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DBManager = [[WZMChatDBManager alloc] init];
    });
    return DBManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //输入框草稿
        _draftDic = [[NSMutableDictionary alloc] init];
        //创建三张表 <user, group, session>
        [[WZMChatSqliteManager defaultManager] createTableName:LL_USER modelClass:[WZMChatUserModel class]];
        [[WZMChatSqliteManager defaultManager] createTableName:LL_GROUP modelClass:[WZMChatGroupModel class]];
        [[WZMChatSqliteManager defaultManager] createTableName:LL_SESSION modelClass:[WZMChatSessionModel class]];
    }
    return self;
}

//草稿
- (NSString *)draftWithModel:(WZMChatBaseModel *)model {
    NSString *key = [self tableNameWithModel:model];
    NSString *draft = [_draftDic objectForKey:key];
    if (draft == nil || ![draft isKindOfClass:[NSString class]]) {
        draft = @"";
    }
    return draft;
}

//删除草稿
- (void)removeDraftWithModel:(WZMChatBaseModel *)model {
    NSString *key = [self tableNameWithModel:model];
    [_draftDic removeObjectForKey:key];
}

//保存草稿
- (void)setDraft:(NSString *)draft model:(WZMChatBaseModel *)model {
    if (draft == nil || ![draft isKindOfClass:[NSString class]]) {
        draft = @"";
    }
    NSString *key = [self tableNameWithModel:model];
    [_draftDic setObject:draft forKey:key];
}

#pragma mark - user表操纵
//所有用户
- (NSMutableArray *)users {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",LL_USER];
    NSArray *list = [[WZMChatSqliteManager defaultManager] selectWithSql:sql];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
    for (NSDictionary *dic in list) {
        WZMChatUserModel *model = [WZMChatUserModel modelWithDic:dic];
        [arr addObject:model];
    }
    return arr;
}

//添加用户
- (void)insertUserModel:(WZMChatUserModel *)model {
    [[WZMChatSqliteManager defaultManager] insertModel:model tableName:LL_USER];
}

//更新用户
- (void)updateUserModel:(WZMChatUserModel *)model {
    [[WZMChatSqliteManager defaultManager] updateModel:model tableName:LL_USER primkey:@"uid"];
}

//查询用户
- (WZMChatUserModel *)selectUserModel:(NSString *)uid {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = '%@'",LL_USER,uid];
    NSArray *list = [[WZMChatSqliteManager defaultManager] selectWithSql:sql];
    if (list.count > 0) {
        WZMChatUserModel *model = [WZMChatUserModel modelWithDic:list.firstObject];
        return model;
    }
    return nil;
}

//删除用户
- (void)deleteUserModel:(NSString *)uid {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = '%@'",LL_USER,uid];
    [[WZMChatSqliteManager defaultManager] execute:sql];
    //同时删除对应的会话
    [self deleteSessionModel:uid];
}

#pragma mark - group表操纵
//所有群
- (NSMutableArray *)groups {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",LL_GROUP];
    NSArray *list = [[WZMChatSqliteManager defaultManager] selectWithSql:sql];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
    for (NSDictionary *dic in list) {
        WZMChatGroupModel *model = [WZMChatGroupModel modelWithDic:dic];
        [arr addObject:model];
    }
    return arr;
}

//添加群
- (void)insertGroupModel:(WZMChatGroupModel *)model {
    [[WZMChatSqliteManager defaultManager] insertModel:model tableName:LL_GROUP];
}

//更新群
- (void)updateGroupModel:(WZMChatGroupModel *)model {
    [[WZMChatSqliteManager defaultManager] updateModel:model tableName:LL_GROUP primkey:@"gid"];
}

//查询群
- (WZMChatGroupModel *)selectGroupModel:(NSString *)gid {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE gid = '%@'",LL_GROUP,gid];
    NSArray *list = [[WZMChatSqliteManager defaultManager] selectWithSql:sql];
    if (list.count > 0) {
        WZMChatGroupModel *model = [WZMChatGroupModel modelWithDic:list.firstObject];
        return model;
    }
    return nil;
}

//删除群
- (void)deleteGroupModel:(NSString *)gid {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE gid = '%@'",LL_GROUP,gid];
    [[WZMChatSqliteManager defaultManager] execute:sql];
    //同时删除对应的会话
    [self deleteSessionModel:gid];
}

#pragma mark - session表操纵
//所有会话
- (NSMutableArray *)sessions {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",LL_SESSION];
    NSArray *list = [[WZMChatSqliteManager defaultManager] selectWithSql:sql];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
    for (NSDictionary *dic in list) {
        WZMChatSessionModel *model = [WZMChatSessionModel modelWithDic:dic];
        [arr addObject:model];
    }
    [arr sortUsingSelector:@selector(compareOtherModel:)];
    return arr;
}

//添加会话
- (void)insertSessionModel:(WZMChatSessionModel *)model {
    [[WZMChatSqliteManager defaultManager] insertModel:model tableName:LL_SESSION];
}

//更新会话
- (void)updateSessionModel:(WZMChatSessionModel *)model {
    [[WZMChatSqliteManager defaultManager] updateModel:model tableName:LL_SESSION primkey:@"sid"];
}

//查询私聊会话
- (WZMChatSessionModel *)selectSessionModelWithUser:(WZMChatUserModel *)userModel {
    return [self selectSessionModel:userModel];
}

//查询群聊会话
- (WZMChatSessionModel *)selectSessionModelWithGroup:(WZMChatGroupModel *)groupModel {
    return [self selectSessionModel:groupModel];
}

//private
- (WZMChatSessionModel *)selectSessionModel:(WZMChatBaseModel *)model {
    NSString *sid, *name, *avatar; BOOL isGroup;
    if ([model isKindOfClass:[WZMChatUserModel class]]) {
        WZMChatUserModel *user = (WZMChatUserModel *)model;
        sid = user.uid;
        name = user.name;
        avatar = user.avatar;
        isGroup = NO;
    }
    else {
        WZMChatGroupModel *group = (WZMChatGroupModel *)model;
        sid = group.gid;
        name = group.name;
        avatar = group.avatar;
        isGroup = YES;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE sid = '%@'",LL_SESSION,sid];
    NSArray *list = [[WZMChatSqliteManager defaultManager] selectWithSql:sql];
    WZMChatSessionModel *session;
    if (list.count > 0) {
        session = [WZMChatSessionModel modelWithDic:list.firstObject];
    }
    else {
        //创建会话,并插入数据库
        session = [[WZMChatSessionModel alloc] init];
        session.sid = sid;
        session.name = name;
        session.avatar = avatar;
        session.cluster = isGroup;
        [self insertSessionModel:session];
    }
    return session;
}

//删除会话
- (void)deleteSessionModel:(NSString *)sid {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE sid = '%@'",LL_SESSION,sid];
    [[WZMChatSqliteManager defaultManager] execute:sql];
}

///查询会话对应的用户或者群聊
- (WZMChatBaseModel *)selectChatModel:(WZMChatSessionModel *)model {
    if (model.isCluster) {
        return [self selectGroupModel:model.sid];
    }
    else {
        return [self selectUserModel:model.sid];
    }
}

//查询会话对应的用户
- (WZMChatUserModel *)selectChatUserModel:(WZMChatSessionModel *)model {
    return [self selectUserModel:model.sid];
}

//查询会话对应的群聊
- (WZMChatGroupModel *)selectChatGroupModel:(WZMChatSessionModel *)model {
    return [self selectGroupModel:model.sid];
}

#pragma mark - message表操纵
//私聊消息
- (NSMutableArray *)messagesWithUser:(WZMChatUserModel *)model {
    return [self messagesWithModel:model];
}

//群聊消息
- (NSMutableArray *)messagesWithGroup:(WZMChatGroupModel *)model {
    return [self messagesWithModel:model];
}

//private
- (NSMutableArray *)messagesWithModel:(WZMChatBaseModel *)model {
    NSString *tableName = [self tableNameWithModel:model];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY timestmp DESC LIMIT 100",tableName];
    NSArray *list = [[WZMChatSqliteManager defaultManager] selectWithSql:sql];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
    for (NSDictionary *dic in list) {
        WZMChatMessageModel *model = [WZMChatMessageModel modelWithDic:dic];
        [arr insertObject:model atIndex:0];
    }
    return arr;
}

//插入私聊消息
- (void)insertMessage:(WZMChatMessageModel *)message chatWithUser:(WZMChatUserModel *)model {
    [self insertMessage:message chatWithModel:model];
}

//插入群聊消息
- (void)insertMessage:(WZMChatMessageModel *)message chatWithGroup:(WZMChatGroupModel *)model {
    [self insertMessage:message chatWithModel:model];
}

//private
- (void)insertMessage:(WZMChatMessageModel *)message chatWithModel:(WZMChatBaseModel *)model{
    WZMChatSessionModel *session = [self selectSessionModel:model];
    session.lastMsg = message.message;
    session.lastTimestmp = message.timestmp;
    [self updateSessionModel:session];
    
    NSString *tableName = [self tableNameWithModel:model];
    [[WZMChatSqliteManager defaultManager] createTableName:tableName modelClass:[message class]];
    [[WZMChatSqliteManager defaultManager] insertModel:message tableName:tableName];
}

//更新私聊消息
- (void)updateMessageModel:(WZMChatMessageModel *)message chatWithUser:(WZMChatUserModel *)model {
    NSString *tableName = [self tableNameWithModel:model];
    [[WZMChatSqliteManager defaultManager] updateModel:message tableName:tableName primkey:@"mid"];
}

//更新群聊消息
- (void)updateMessageModel:(WZMChatMessageModel *)message chatWithGroup:(WZMChatGroupModel *)model {
    NSString *tableName = [self tableNameWithModel:model];
    [[WZMChatSqliteManager defaultManager] updateModel:message tableName:tableName primkey:@"mid"];
}

//private
- (NSString *)tableNameWithModel:(WZMChatBaseModel *)model {
    if ([model isKindOfClass:[WZMChatUserModel class]]) {
        WZMChatUserModel *user = (WZMChatUserModel *)model;
        return [NSString stringWithFormat:@"user_%@",user.uid];
    }
    else {
        WZMChatGroupModel *group = (WZMChatGroupModel *)model;
        return [NSString stringWithFormat:@"group_%@",group.gid];
    }
}

@end

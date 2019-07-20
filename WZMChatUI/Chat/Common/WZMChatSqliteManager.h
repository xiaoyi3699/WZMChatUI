//
//  WZMChatSqliteManager.h
//  LLFoundation
//
//  Created by Mr.Wang on 16/12/30.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//  数据库实现

#import <Foundation/Foundation.h>

@interface WZMChatSqliteManager : NSObject

+ (instancetype)defaultManager;
- (BOOL)createTableName:(NSString *)tableName modelClass:(Class)modelClass;
- (BOOL)insertModel:(id)model tableName:(NSString *)tableName;
- (BOOL)deleteModel:(id)model tableName:(NSString *)tableName primkey:(NSString *)primkey;
- (BOOL)updateModel:(id)model tableName:(NSString *)tableName primkey:(NSString *)primkey;

- (long)execute:(NSString *)sql;
- (BOOL)deleteDataBase:(NSError **)error;
- (BOOL)deleteTableName:(NSString *)tableName;
- (NSMutableArray *)selectWithSql:(NSString *)sql;

@end

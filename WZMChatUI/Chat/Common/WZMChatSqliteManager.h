//
//  WZMChatSqliteManager.h
//  LLFoundation
//
//  Created by Mr.Wang on 16/12/30.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//  数据库实现

#import <Foundation/Foundation.h>

@interface WZMChatSqliteManager : NSObject

///是否自动管理db,默认YES
///关闭后,须手动调用manualOpenDataBase和manualCloseDataBase管理
@property (nonatomic, assign, getter=isAutoManager) BOOL autoManager;
///默认数据库
+ (instancetype)shareManager;
///创建自定义路径的数据库
- (instancetype)initWithDBPath:(NSString *)dataBasePath;
- (NSString *)dataBasePath;
- (BOOL)createTableName:(NSString *)tableName modelClass:(Class)modelClass hasId:(BOOL)hasId;
- (BOOL)insertModel:(id)model tableName:(NSString *)tableName;
- (BOOL)deleteModel:(id)model tableName:(NSString *)tableName primkey:(NSString *)primkey;
- (BOOL)updateModel:(id)model tableName:(NSString *)tableName primkey:(NSString *)primkey;
/**
 查询model
 where - 如：py = 'w' 或 py LIKE 'w%'
 orderBy - 如：ORDER BY score DESC
 limit - 如：5
 注意：要重载calss的-[setValue:forUndefinedKey:]
 */
- (NSMutableArray *)selectModels:(Class)model tableName:(NSString *)tableName where:(NSString *)where orderBy:(NSString *)orderBy limit:(NSInteger)limit;

- (BOOL)insertColumns:(NSArray *)columnNames tableName:(NSString *)tableName;
- (BOOL)deleteColumns:(NSArray *)columnNames tableName:(NSString *)tableName;

- (NSString *)getErrorMessage;
- (BOOL)execute:(NSString *)sql;
- (BOOL)deleteTableName:(NSString *)tableName;
- (NSMutableArray *)selectWithSql:(NSString *)sql;

- (BOOL)manualOpenDataBase;
- (BOOL)manualCloseDataBase;

@end

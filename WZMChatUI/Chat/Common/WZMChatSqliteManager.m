//
//  WZMChatSqliteManager.m
//  LLFoundation
//
//  Created by Mr.Wang on 16/12/30.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMChatSqliteManager.h"
#import "WZMChatBaseModel.h"
#import "NSObject+WZMChat.h"
#import <objc/runtime.h>
#import <sqlite3.h>

@interface WZMChatSqliteManager () {
    NSString *_dataBasePath;
    sqlite3 *_sql3;
    BOOL _opened;
    NSMutableDictionary *_modelAttDic;
}
@end

@implementation WZMChatSqliteManager

/**
 数据库操纵单例
 */
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static WZMChatSqliteManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[WZMChatSqliteManager alloc] init];
    });
    return manager;
}

//创建自定义数据库
- (instancetype)initWithDBPath:(NSString *)dataBasePath {
    self = [super init];
    if (self) {
        _dataBasePath = dataBasePath;
        [self setConfig];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setConfig];
    }
    return self;
}

- (void)setConfig {
    self.autoManager = YES;
    _modelAttDic = [[NSMutableDictionary alloc] init];
}

/**
 根据-模型类-创建表
 */
- (BOOL)createTableName:(NSString *)tableName modelClass:(Class)modelClass hasId:(BOOL)hasId {
    if ([self openDataBase]) {
        if ([self isTableExist:tableName]) {
            //数据库中该表存在
            [self closeDataBase];
            return YES;
        }
        else {
            //CREATE TABLE if not exists
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@(",tableName];
            if (hasId) {
                sql = [NSString stringWithFormat:@"%@id integer primary key autoincrement",sql];
            }
            NSArray *propertys = [WZMChatSqliteManager chat_allPropertyNameInClass:modelClass];
            
            for (NSDictionary *dic in propertys) {
                sql = [NSString stringWithFormat:@"%@,%@ %@",sql,dic[@"name"],dic[@"type"]];
            }
            sql = [sql stringByAppendingString:@")"];
            if (hasId == NO) {
                sql = [sql stringByReplacingOccurrencesOfString:@"(," withString:@"("];
            }
            int result = sqlite3_exec(_sql3, sql.UTF8String, NULL, NULL, NULL);
            if (result != SQLITE_OK) {
                //NSAssert(NO, @"数据库-创建-失败");
                NSLog(@"数据库-创建-失败");
            }
            [self closeDataBase];
            return (result == SQLITE_OK);
        }
    }
    return NO;
}

//查询表的所有字段
- (NSArray *)tableInfo:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
    if ([self openDataBase]) {
        sqlite3_stmt *stmt = nil;
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        int res = sqlite3_prepare(_sql3, sql.UTF8String, -1, &stmt, NULL);
        if (res == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char *nameData = (char *)sqlite3_column_text(stmt, 1);
                NSString *columnName = [[NSString alloc] initWithUTF8String:nameData];
                [array addObject:columnName];
            }
        }
        sqlite3_finalize(stmt);
        [self closeDataBase];
        return [array copy];
    }
    return nil;
}

/**
 插入数据-模型
 */
- (BOOL)insertModel:(id)model tableName:(NSString *)tableName{
    NSDictionary *dic = [WZMChatSqliteManager chat_dictionaryFromModel:model];
    return [self insertDic:dic tableName:tableName];
}

- (BOOL)insertDic:(NSDictionary *)dic tableName:(NSString *)tableName{
    NSMutableString *keys = [NSMutableString string];
    NSMutableString *values = [NSMutableString string];
    for (int i = 0; i < dic.count; i++) {
        NSString *key = dic.allKeys[i];
        NSString *value = dic.allValues[i];
        if (value == nil) {
            value = @"";
        }
        [keys appendFormat:@"`%@`,",key];
        [values appendFormat:@"'%@',",value];
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) values(%@)",tableName,[keys substringToIndex:keys.length-1],[values substringToIndex:values.length-1]];
    return [self execute:sql];
}

/**
 删除
 */
- (BOOL)deleteModel:(id)model tableName:(NSString *)tableName primkey:(NSString *)primkey{
    NSDictionary *dic = [WZMChatSqliteManager chat_dictionaryFromModel:model];
    return [self deleteDic:dic tableName:tableName primkey:primkey];
}

- (BOOL)deleteDic:(NSDictionary *)dic tableName:(NSString *)tableName primkey:(NSString *)primkey{
    NSString *keySql = nil;
    for (int i = 0; i < dic.count; i++) {
        NSString *key = dic.allKeys[i];
        NSString *value = dic.allValues[i];
        
        if ([primkey isEqualToString:key]) {
            keySql = [NSString stringWithFormat:@"`%@`='%@'", primkey, value];
            break;
        }
    }
    if (keySql == nil) {
        NSLog(@"数据库删除失败:字段[%@]不存在",primkey);
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",tableName,keySql];
    NSLog(@"%@",sql);
    return [self execute:sql];
}

/**
 更新
 */
- (BOOL)updateModel:(id)model tableName:(NSString *)tableName primkey:(NSString *)primkey{
    NSDictionary *dic = [WZMChatSqliteManager chat_dictionaryFromModel:model];
    return [self updateDic:dic tableName:tableName primkey:primkey];
}

- (BOOL)updateDic:(NSDictionary *)dic tableName:(NSString *)tableName primkey:(NSString *)primkey{
    NSString *keySql = nil;
    NSMutableString *values = [NSMutableString string];
    for (int i = 0; i < dic.count; i++) {
        NSString *key = dic.allKeys[i];
        NSString *value = dic.allValues[i];
        
        if ([primkey isEqualToString:key]) {
            keySql = [NSString stringWithFormat:@"`%@`='%@'", primkey, value];
            continue;
        }
        [values appendFormat:@"`%@`='%@',", key, value];
    }
    if (keySql == nil) {
        NSLog(@"数据库更新失败:字段[%@]不存在",primkey);
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ where %@",tableName,[values substringToIndex:values.length - 1], keySql];
    NSLog(@"%@",sql);
    return [self execute:sql];
}

- (BOOL)insertColumns:(NSArray *)columnNames tableName:(NSString *)tableName {
    NSArray *exColumns = [self insertValidColumns:columnNames tableName:tableName];
    //拼接查询语句
    NSMutableArray *sqls = [[NSMutableArray alloc] init];
    for (NSString *column in exColumns) {
        NSString *sql = [NSString stringWithFormat:@"alter table %@ add %@ text default ''",tableName,column];
        [sqls addObject:sql];
    }
    return [self executes:sqls];
}

- (NSArray *)insertValidColumns:(NSArray *)columnNames tableName:(NSString *)tableName {
    NSMutableArray *exColumns = [columnNames mutableCopy];
    //查询数据库现有字段
    NSArray *columns = [self tableInfo:tableName];
    //遍历数据库现有字段
    for (NSString *column in columns) {
        //判断新增字段是否存在
        if ([exColumns containsObject:column]) {
            [exColumns removeObject:column];
        }
    }
    return [exColumns copy];
}

- (BOOL)deleteColumns:(NSArray *)columnNames tableName:(NSString *)tableName {
    NSArray *exColumns = [self deleteValidColumns:columnNames tableName:tableName];
    //拼接查询语句
    NSMutableArray *sqls = [[NSMutableArray alloc] init];
    for (NSString *column in exColumns) {
        NSString *sql = [NSString stringWithFormat:@"alter table %@ drop column %@",tableName,column];
        [sqls addObject:sql];
    }
    return [self executes:sqls];
}

- (NSArray *)deleteValidColumns:(NSArray *)columnNames tableName:(NSString *)tableName {
    NSMutableArray *exColumns = [columnNames mutableCopy];
    //查询数据库现有字段
    NSArray *columns = [self tableInfo:tableName];
    //遍历将要删除的字段
    for (NSString *columnName in columnNames) {
        //判断数据库是否存在该字段
        if ([columns containsObject:columnName] == NO) {
            [exColumns removeObject:columnName];
        }
    }
    return [exColumns copy];
}

- (BOOL)execute:(NSString *)sql{
    BOOL success = NO;
    if ([self openDataBase]) {
        int res = sqlite3_exec(_sql3, sql.UTF8String, NULL, NULL, NULL);
        if (res == SQLITE_OK){
            success = YES;
            //最后插入记录的id
            //long insertId = (long)sqlite3_last_insert_rowid(_sql3);
        }
        [self closeDataBase];
    }
    return success;
}

- (BOOL)executes:(NSArray *)sqls {
    if (sqls.count == 0) return NO;
    BOOL success = NO;
    if ([self openDataBase]) {
        for (NSString *sql in sqls) {
            int res = sqlite3_exec(_sql3, sql.UTF8String, NULL, NULL, NULL);
            if (res == SQLITE_OK) {
                //最后插入记录的id
                //long insertId = (long)sqlite3_last_insert_rowid(_sql3);
                if (success == NO) {
                    success = YES;
                }
            }
        }
        [self closeDataBase];
    }
    return success;
}

- (NSString *)getErrorMessage {
    const char *error = sqlite3_errmsg(_sql3);
    NSString *msg = [[NSString alloc] initWithCString:error encoding:NSASCIIStringEncoding];
    return msg;
}

/**
 查询
 */
- (NSMutableArray *)selectWithSql:(NSString *)sql{
    if ([self openDataBase]) {
        sqlite3_stmt *stmt = nil;
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        int res = sqlite3_prepare(_sql3, sql.UTF8String, -1, &stmt, NULL);
        if (res == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                int count = sqlite3_column_count(stmt);
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
                for (int i = 0; i < count; i++) {
                    const char *columName = sqlite3_column_name(stmt, i);
                    const char *value = (const char*)sqlite3_column_text(stmt, i);
                    if (value != NULL) {
                        NSString *columValue = [NSString stringWithUTF8String:value];
                        [dic setValue:columValue forKey:[NSString stringWithUTF8String:columName]];
                    }else{
                        [dic setValue:@"" forKey:[NSString stringWithUTF8String:columName]];
                    }
                }
                [array addObject:dic];
            }
        }
        sqlite3_finalize(stmt);
        [self closeDataBase];
        return array;
    }
    return nil;
}

- (NSMutableArray *)selectModels:(Class)class tableName:(NSString *)tableName where:(NSString *)where orderBy:(NSString *)orderBy limit:(NSInteger)limit {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    if (where.length) {
        //如：py = 'w' 或 py LIKE 'w%'
        sql = [NSString stringWithFormat:@"%@ WHERE %@",sql,where];
    }
    if (orderBy.length) {
        //如：ORDER BY score DESC
        sql = [NSString stringWithFormat:@"%@ %@",sql,orderBy];
    }
    if (limit > 0) {
        //如：5
        sql = [NSString stringWithFormat:@"%@ LIMIT %@",sql,@(limit)];
    }
    //查询
    NSDictionary *attDic = [WZMChatSqliteManager chat_allPropertyNameInClass2:class];
    NSArray *list = [self selectWithSql:sql];
    NSMutableArray *rsts = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in list) {
        id c = [class new];
        for (NSString *key in dic.allKeys) {
            NSString *value = [dic valueForKey:key];
            if (key && value) {
                NSString *type = [attDic objectForKey:key];
                if ([type isEqualToString:@"integer"]) {
                    [c setValue:@([value integerValue]) forKey:key];
                }
                else if ([type isEqualToString:@"real"]) {
                    [c setValue:@([value floatValue]) forKey:key];
                }
                else if ([type isEqualToString:@"boolean"]) {
                    [c setValue:@([value boolValue]) forKey:key];
                }
                else if ([type isEqualToString:@"text"]) {
                    [c setValue:value forKey:key];
                }
            }
        }
        [rsts addObject:c];
    }
    return rsts;
}

/**
 删除表
 */
- (BOOL)deleteTableName:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    return [self execute:sql];
}

#pragma mark - private
/*
 创建存储数据库的路径
 */
- (NSString *)dataBasePath{
    if (!_dataBasePath) {
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _dataBasePath = [document stringByAppendingPathComponent:@"LLDataBase.sqlite"];
    }
    return _dataBasePath;
}

/*
 打开数据库
 */
- (BOOL)openDataBase{
    if (self.isAutoManager) {
        return [self openDB];
    }
    return YES;
}

- (BOOL)manualOpenDataBase {
    if (self.isAutoManager == NO) {
        return [self openDB];
    }
    return NO;
}

- (BOOL)openDB {
    if (_opened) return YES;
    _opened = YES;
    const char *filePath = [[self dataBasePath] UTF8String];
    int result = sqlite3_open(filePath, &_sql3);
    if (result == SQLITE_OK) {
        return YES;
    }
    else{
        _opened = NO;
        sqlite3_close(_sql3);
        //NSAssert(NO, @"数据库-打开-失败");
        NSLog(@"数据库-打开-失败");
        return NO;
    }
}

/*
 关闭数据库
 */
- (BOOL)closeDataBase{
    if (self.isAutoManager) {
        return [self closeDB];
    }
    return YES;
}

- (BOOL)manualCloseDataBase {
    if (self.isAutoManager == NO) {
        return [self closeDB];
    }
    return NO;
}

- (BOOL)closeDB {
    if (_opened == NO) return YES;
    _opened = NO;
    return !sqlite3_close(_sql3);
}

/*
 判断表是否存在
 */
- (BOOL)isTableExist:(NSString *)tableName{
    BOOL exist = NO;
    sqlite3_stmt *stmt;
    NSString *sql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master where type='table' and name='%@'",tableName];
    if (sqlite3_prepare_v2(_sql3, sql.UTF8String, -1, &stmt, nil) == SQLITE_OK){
        int temp = sqlite3_step(stmt);
        if (temp == SQLITE_ROW){
            exist = YES;
        }
    }
    sqlite3_finalize(stmt);
    return exist;
}

@end

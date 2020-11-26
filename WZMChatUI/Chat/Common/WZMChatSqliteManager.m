//
//  WZMChatSqliteManager.m
//  LLFoundation
//
//  Created by Mr.Wang on 16/12/30.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMChatSqliteManager.h"
#import "WZMChatBaseModel.h"
#import <objc/runtime.h>
#import <sqlite3.h>

@interface WZMChatSqliteManager () {
    NSString *_dataBasePath;
    sqlite3 *_sql3;
    BOOL _opened;
}
@end

@implementation WZMChatSqliteManager

/**
 数据库操纵单例
 */
+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    static WZMChatSqliteManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[WZMChatSqliteManager alloc] init];
    });
    return manager;
}

/**
 根据-模型类-创建表
 */
- (BOOL)createTableName:(NSString *)tableName modelClass:(Class)modelClass{
    if ([self openDataBase]) {
        if ([self isTableExist:tableName]) {//数据库中该表存在
            [self closeDataBase];
            return YES;
        }
        else{//CREATE TABLE if not exists
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@(id integer primary key autoincrement",tableName];
            NSArray *propertys = [self allPropertyNameInClass:modelClass];
            
            for (NSDictionary *dic in propertys) {
                sql = [NSString stringWithFormat:@"%@,%@ %@",sql,dic[@"name"],dic[@"type"]];
            }
            sql = [sql stringByAppendingString:@")"];
            
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

/**
 插入数据-模型
 */
- (BOOL)insertModel:(id)model tableName:(NSString *)tableName{
    NSDictionary *dic = [self DictionaryFromModel:model];
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
    return ![self execute:sql];
}

/**
 删除
 */
- (BOOL)deleteModel:(id)model tableName:(NSString *)tableName primkey:(NSString *)primkey{
    NSDictionary *dic = [self DictionaryFromModel:model];
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
    return ![self execute:sql];
}

/**
 更新
 */
- (BOOL)updateModel:(id)model tableName:(NSString *)tableName primkey:(NSString *)primkey{
    NSDictionary *dic = [self DictionaryFromModel:model];
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
    return ![self execute:sql];
}

- (long)execute:(NSString *)sql{
    long insertId = 0;
    if ([self openDataBase]) {
        int res = sqlite3_exec(_sql3, sql.UTF8String, NULL, NULL, NULL);
        if (res == SQLITE_OK){
            insertId = (long)sqlite3_last_insert_rowid(_sql3);
        }
        [self closeDataBase];
    }
    return insertId;
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

/*
 删除数据库
 */
- (BOOL)deleteDataBase:(NSError **)error {
    NSString *filePath = [self dataBasePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:error];
    }
    return YES;
}

/**
 删除表
 */
- (BOOL)deleteTableName:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    return ![self execute:sql];
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
-(BOOL)closeDataBase{
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

#pragma merk - runtime
/*
 获取类的所有属性名称与类型
 */
- (NSArray *)allPropertyNameInClass:(Class)cls{
    if ([cls isSubclassOfClass:[WZMChatBaseModel class]]) {
        return [cls allPropertyName];
    }
    NSMutableArray *arr = [NSMutableArray array];
    unsigned int count;
    objc_property_t *pros = class_copyPropertyList(cls, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t pro = pros[i];
//        NSString *attributes = [NSString stringWithFormat:@"%s", property_getAttributes(pro)];
//        if ([attributes containsString:@",R,"]) {
//            continue;
//        }
        NSString *name =[NSString stringWithFormat:@"%s",property_getName(pro)];
        NSString *type = [self attrValueWithName:@"T" InProperty:pros[i]];
        //类型转换
        if ([type isEqualToString:@"q"]||[type isEqualToString:@"i"]||[type isEqualToString:@"I"]) {
            type = @"integer";
        }else if([type isEqualToString:@"f"] || [type isEqualToString:@"d"]){
            type = @"real";
        }else if([type isEqualToString:@"B"]){
            type = @"boolean";
        }else{
            type = @"text";
        }
        NSDictionary *dic = @{@"name":name,@"type":type};
        [arr addObject:dic];
    }
    free(pros);
    return arr;
}

/*
 获取属性的特征值
 */
- (NSString*)attrValueWithName:(NSString*)name InProperty:(objc_property_t)pro{
    unsigned int count = 0;
    objc_property_attribute_t *attrs = property_copyAttributeList(pro, &count);
    for (int i = 0; i < count; i++) {
        objc_property_attribute_t attr = attrs[i];
        if (strcmp(attr.name, name.UTF8String) == 0) {
            return [NSString stringWithUTF8String:attr.value];
        }
    }
    free(attrs);
    return nil;
}

/*
 对象转换为字典
 */
- (NSDictionary *)DictionaryFromModel:(id)model{
    if ([model isKindOfClass:[WZMChatBaseModel class]]) {
        return [model transfromDictionary];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    Class modelClass = object_getClass(model);
    unsigned int count = 0;
    objc_property_t *pros = class_copyPropertyList(modelClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t pro = pros[i];
        NSString *name = [NSString stringWithFormat:@"%s", property_getName(pro)];
        id value = [model valueForKey:name];
        if (value != nil) {
            [dic setValue:value forKey:name];
        }
    }
    free(pros);
    return dic;
}

@end

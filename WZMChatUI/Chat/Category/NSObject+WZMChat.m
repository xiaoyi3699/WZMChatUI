//
//  NSObject+WZMChat.m
//  WZMChatUI
//
//  Created by Zhaomeng Wang on 2022/3/24.
//  Copyright © 2022 WangZhaomeng. All rights reserved.
//

#import "NSObject+WZMChat.h"
#import <objc/runtime.h>

@interface WZMChatObjectHelper : NSObject

@property (nonatomic, strong) NSMutableArray *propertys;

@end

@implementation WZMChatObjectHelper

+ (instancetype)shareHelper {
    static id helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.propertys = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 4; i ++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [self.propertys addObject:dic];
        }
    }
    return self;
}

@end

@implementation NSObject (WZMChat)

///对象转换为字典
+ (NSDictionary *)chat_dictionaryFromModel:(id)model {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    Class modelClass = object_getClass(model);
    unsigned int count = 0;
    objc_property_t *pros = class_copyPropertyList(modelClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t pro = pros[i];
//        NSString *attributes = [NSString stringWithFormat:@"%s", property_getAttributes(pro)];
//        if ([attributes containsString:@",R,"]) {
//            continue;
//        }
        NSString *name = [NSString stringWithFormat:@"%s", property_getName(pro)];
        id value = [model valueForKey:name];
        if (value != nil) {
            [dic setValue:value forKey:name];
        }
    }
    free(pros);
    return dic;
}

///获取类的所有属性名称与类型
+ (NSArray *)chat_allPropertyNameInClass:(Class)cls {
    WZMChatObjectHelper *helper = [WZMChatObjectHelper shareHelper];
    NSMutableDictionary *sDic = helper.propertys[0];
    NSString *key = NSStringFromClass(cls);
    NSMutableArray *arr = [sDic objectForKey:key];
    if (arr == nil) {
        arr = [[NSMutableArray alloc] init];
        unsigned int count;
        objc_property_t *pros = class_copyPropertyList(cls, &count);
        for (int i = 0; i < count; i++) {
            objc_property_t pro = pros[i];
    //        NSString *attributes = [NSString stringWithFormat:@"%s", property_getAttributes(pro)];
    //        if ([attributes containsString:@",R,"]) {
    //            continue;
    //        }
            NSString *name =[NSString stringWithFormat:@"%s",property_getName(pro)];
            NSString *type = [self chat_attrValueWithName:@"T" InProperty:pros[i]];
            //类型转换
            type = [self chat_getTypeWithType:type];
            NSDictionary *dic = @{@"name":name,@"type":type};
            [arr addObject:dic];
        }
        free(pros);
        [sDic setValue:arr forKey:key];
    }
    return arr;
}

+ (NSDictionary *)chat_allPropertyNameInClass2:(Class)cls {
    WZMChatObjectHelper *helper = [WZMChatObjectHelper shareHelper];
    NSMutableDictionary *sDic = helper.propertys[1];
    NSString *key = NSStringFromClass(cls);
    NSMutableDictionary *dic = [sDic objectForKey:key];
    if (dic == nil) {
        dic = [[NSMutableDictionary alloc] init];
        unsigned int count;
        objc_property_t *pros = class_copyPropertyList(cls, &count);
//        NSString *attributes = [NSString stringWithFormat:@"%s", property_getAttributes(pro)];
//        if ([attributes containsString:@",R,"]) {
//            continue;
//        }
        for (int i = 0; i < count; i++) {
            objc_property_t pro = pros[i];
            NSString *name =[NSString stringWithFormat:@"%s",property_getName(pro)];
            NSString *type = [self chat_attrValueWithName:@"T" InProperty:pros[i]];
            //类型转换
            type = [self chat_getTypeWithType:type];
            [dic setValue:type forKey:name];
        }
        free(pros);
        [sDic setValue:dic forKey:key];
    }
    return dic;
}

+ (NSDictionary *)chat_allPropertyNameInClass3:(Class)cls {
    WZMChatObjectHelper *helper = [WZMChatObjectHelper shareHelper];
    NSMutableDictionary *sDic = helper.propertys[2];
    NSString *key = NSStringFromClass(cls);
    NSMutableDictionary *dic = [sDic objectForKey:key];
    if (dic == nil) {
        dic = [[NSMutableDictionary alloc] init];
        unsigned int count;
        objc_property_t *pros = class_copyPropertyList(cls, &count);
//        NSString *attributes = [NSString stringWithFormat:@"%s", property_getAttributes(pro)];
//        if ([attributes containsString:@",R,"]) {
//            continue;
//        }
        for (int i = 0; i < count; i++) {
            objc_property_t pro = pros[i];
            NSString *name =[NSString stringWithFormat:@"%s",property_getName(pro)];
            NSString *type = [self chat_attrValueWithName:@"T" InProperty:pros[i]];
            //类型转换
            type = [self chat_getTypeWithType:type];
            [dic setValue:type forKey:name];
        }
        free(pros);
        
        //_的所有属性
        NSMutableDictionary *_dic = [[NSMutableDictionary alloc] init];
        Ivar *ivarLists = class_copyIvarList(cls, &count);
        for (int i = 0; i < count; i++) {
            Ivar v = ivarLists[i];
            NSString *name = [NSString stringWithUTF8String:ivar_getName(v)];
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(v)];
            //类型转换
            type = [self chat_getTypeWithType:type];
            [_dic setValue:type forKey:name];
        }
        free(ivarLists);
        if (_dic.count) {
            [dic setValue:_dic forKey:@"_ivar"];
        }
        [sDic setValue:dic forKey:key];
    }
    return dic;
}

+ (NSString *)chat_attrValueWithName:(NSString*)name InProperty:(objc_property_t)pro{
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

+ (NSString *)chat_getTypeWithType:(NSString *)type {
    if ([type isEqualToString:@"q"]||[type isEqualToString:@"Q"]||[type isEqualToString:@"i"]||[type isEqualToString:@"I"]) {
        type = @"integer";
    }else if([type isEqualToString:@"f"] || [type isEqualToString:@"d"]){
        type = @"real";
    }else if([type isEqualToString:@"B"]){
        type = @"boolean";
    }else{
        type = @"text";
    }
    return type;
}

@end

//
//  LLChatBaseModel.h
//  LLChat
//
//  Created by WangZhaomeng on 2019/4/26.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLChatBaseModel : NSObject<NSCoding>

///将字典转化为model
+ (instancetype)modelWithDic:(NSDictionary *)dic;

///将model转化为字典
- (NSDictionary *)transfromDictionary;

///获取类的所有属性名称与类型, 使用LLChatBaseModel的子类调用
+ (NSArray *)allPropertyName;

///解档
+ (instancetype)ll_unarchiveObjectWithData:(NSData *)data;

@end

@interface NSData (LLChatBaseModel)

///归档
+ (NSData *)ll_archivedDataWithModel:(LLChatBaseModel *)model;

@end

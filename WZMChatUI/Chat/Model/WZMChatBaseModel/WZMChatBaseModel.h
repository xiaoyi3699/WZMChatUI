//
//  WZMChatBaseModel.h
//  WZMChat
//
//  Created by WangZhaomeng on 2019/4/26.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZMChatBaseModel : NSObject<NSCoding>

///将字典转化为model
+ (instancetype)modelWithDic:(NSDictionary *)dic;

///将model转化为字典
- (NSDictionary *)transfromDictionary;

///获取类的所有属性名称与类型, 使用WZMChatBaseModel的子类调用
+ (NSArray *)allPropertyName;

///解档
+ (instancetype)wzm_unarchiveObjectWithData:(NSData *)data;

@end

@interface NSData (WZMChatBaseModel)

///归档
+ (NSData *)wzm_archivedDataWithModel:(WZMChatBaseModel *)model;

@end

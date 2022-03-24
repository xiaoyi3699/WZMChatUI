//
//  NSObject+WZMChat.h
//  WZMChatUI
//
//  Created by Zhaomeng Wang on 2022/3/24.
//  Copyright © 2022 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WZMChat)

///对象转换为字典
+ (NSDictionary *)chat_dictionaryFromModel:(id)model;
///获取类的所有属性名称与类型
+ (NSArray *)chat_allPropertyNameInClass:(Class)cls;
+ (NSDictionary *)chat_allPropertyNameInClass2:(Class)cls;
+ (NSDictionary *)chat_allPropertyNameInClass3:(Class)cls;

@end

NS_ASSUME_NONNULL_END

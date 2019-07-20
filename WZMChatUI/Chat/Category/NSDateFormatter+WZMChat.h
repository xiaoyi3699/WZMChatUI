//
//  NSDateFormatter+WZMChat.h
//  WZMChat
//
//  Created by WangZhaomeng on 2019/7/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (WZMChat)

+ (NSDateFormatter *)ll_defaultDateFormatter;
+ (NSDateFormatter *)ll_detailDateFormatter;
+ (NSDateFormatter *)ll_dateFormatter:(NSString *)f;

@end

NS_ASSUME_NONNULL_END

//
//  NSDateFormatter+WZMChat.h
//  WZMChat
//
//  Created by WangZhaomeng on 2019/7/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (WZMChat)

+ (NSDateFormatter *)wzm_defaultDateFormatter;
+ (NSDateFormatter *)wzm_detailDateFormatter;
+ (NSDateFormatter *)wzm_dateFormatter:(NSString *)f;

@end
